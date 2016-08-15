class BookingController < ApplicationController
  def new
    @resource = Resource.find_by_name!(params[:name])
    @remainingFreeTime = get_remaining_free_time(@resource)
    @pricing_cents = (!current_user.nil? && current_user.has_subscription?) ? @resource.pricing_cents_member : @resource.pricing_cents
  end

  def pay
    @date = Date.strptime(params[:date], '%Y-%m-%d')
    @start_time = Time.strptime(params[:timeFrom], '%H:%M')
    @end_time = Time.strptime(params[:timeTo], '%H:%M')
    @title = params[:title].chomp
    if !@date or !@start_time or !@end_time or !@title
      render :json => {error: 'Error parsing date or time'}
      return
    end
    if @date < Date.today or (@date == Date.today and @start_time < Time.now)
      render :json => {error: 'Must be date in the future'}
      return
    end
    @resource = Resource.find_by_name!(params[:name])
    if Booking.where('resource_id=:resource_id and book_date=:book_date and ((time_to >= :start_date and time_from >= :start_date)
                   or (time_to >= :end_date and time_from >= :end_date))',
                     {resource_id: @resource.id, start_date: Time.zone.local_to_utc(@start_time), end_date: Time.zone.local_to_utc(@end_time), book_date: @date}).take
      render :json => {error: 'Already booked'}
      return
    end
    @remainingFreeTime = get_remaining_free_time(@resource)
    @duration = ((((@end_time - @start_time) / 1.hour) * 2).round / 2.0 - @remainingFreeTime).to_i

    @should_pay = true
    if params.has_key?(:manager) and params[:manager] == 'true'
      if current_user.nil? or !current_user.manager?
        render :json => {error: 'Not a manager'}
        return
      end
      @should_pay = false
    end

    @stripe_payment_id = ''
    if @duration > 0 and @should_pay
      begin
        @stripe_payment = Stripe::Charge.create(
            amount: @duration * (current_user.has_subscription? ? @resource.pricing_cents_member : @resource.pricing_cents),
            currency: 'aud',
            source: params[:stripeToken],
            description: 'Booking the ' + @resource.full_name
        )
        @stripe_payment_id = @stripe_payment.id
      rescue => e
        render :json => {error: 'Error charging supplied card.'}
        puts e
        return
      end
    end
    @booking = nil
    if current_user
      @booking = @resource.bookings.create(title: @title,
                                           user_id: current_user.id,
                                           time_from: Time.zone.local_to_utc(@start_time),
                                           time_to: Time.zone.local_to_utc(@end_time),
                                           stripe_payment_id: @stripe_payment_id,
                                           charge_cents: !@stripe_payment.nil? ? @stripe_payment.amount : 0,
                                           book_date: @date)
    else
      @booking = @resource.bookings.create(title: @title,
                                           time_from: Time.zone.local_to_utc(@start_time),
                                           time_to: Time.zone.local_to_utc(@end_time),
                                           stripe_payment_id: @stripe_payment_id,
                                           charge_cents: !@stripe_payment.nil? ? @stripe_payment.amount : 0,
                                           book_date: @date)
    end

    api_client = Google::APIClient.new
    api_client.retries = 3
    cal = api_client.discovered_api('calendar', 'v3')
    new_event = cal.events.insert.request_schema.new
    perth_tz = ActiveSupport::TimeZone.new('Australia/Perth').utc_offset
    cal_start_time = @start_time.change(:year => @date.year, :month => @date.month, :day => @date.day).in_time_zone('Australia/Perth') + -perth_tz
    cal_end_time = @end_time.change(:year => @date.year, :month => @date.month, :day => @date.day).in_time_zone('Australia/Perth') + -perth_tz
    new_event.start = {
        dateTime: cal_start_time.to_formatted_s(:iso8601),
        timeZone: 'Australia/Perth'
    }
    new_event.end = {
        dateTime: cal_end_time.to_formatted_s(:iso8601),
        timeZone: 'Australia/Perth'
    }
    new_event.summary = @title + " - #{current_user.firstname} #{current_user.lastname}"
    result = api_client.execute(:api_method => cal.events.insert,
                                :authorization => Rails.configuration.google_calendar[:auth_client],
                                :parameters => {calendarId: @resource.google_calendar_id},
                                :headers => {'Content-Type'.freeze => 'application/json'.freeze},
                                :body_object => new_event)
    if result.data.try(:error)
      puts 'error'
      @booking.delete
      @stripe_payment.refund
      puts result.data.inspect
      render :json => {error: 'Google Calendar error.'}
    else
      render :json => {id: @booking.id}
    end
  end

  def confirmation
    @booking = Booking.find(params[:id])
    if @booking.user_id and (!current_user or current_user.id != @booking.user_id)
      render 500
      return
    end
    @remainingFreeTime = get_remaining_free_time(@booking.resource)
  end

  private

  def get_remaining_free_time(resource)
    time = 0
    if current_user and current_user.has_subscription?
      time = max(0, 2 - resource.calculate_booked_week_time(current_user))
    end
    time
  end
end
