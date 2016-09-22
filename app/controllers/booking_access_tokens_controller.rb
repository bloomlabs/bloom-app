class BookingAccessTokensController < ApplicationController
  before_action :authenticate_user!, only: [:signup]

  def signup
    @token = BookingAccessToken.find_by_token(params[:uuid])
    if @token.nil?
      head 404
    elsif @token.signup_expiry < Date.today
      render 'token_expired'
    else
      if UserBookingAccessToken.find_by_booking_access_token_id(@token.id).nil?
        UserBookingAccessToken.create!(user_id: current_user.id, booking_access_token_id: @token.id)
      end
      flash[:notice] = 'Booking access added successfully'
      redirect_to '/booking/serious/new'
    end
  end

  def index
    head 422 and return if current_user.nil? or not current_user.manager?
    @tokens = BookingAccessToken.where('expiry >= ?', Date.today)
  end

  def show
    head 422 and return if current_user.nil? or not current_user.manager?
    @token = BookingAccessToken.find_by_id!(params[:id])
  end

  def new
    head 422 and return if current_user.nil? or not current_user.manager?
    @token = BookingAccessToken.new
  end

  def create
    head 422 and return if current_user.nil? or not current_user.manager?
    if params[:resources].empty?
      flash[:error] = 'At least one resource must be selected'
      render :new and return
    end
    @token = BookingAccessToken.new(params.require(:booking_access_token).permit(:discount, :expiry, :signup_expiry))
    @token.token = SecureRandom.uuid

    if @token.save
      params[:resources].each do |resource_id|
        @token_resource = BookingAccessTokenResource.new(resource_id: resource_id, booking_access_token_id: @token.id)
        if not @token_resource.save
          flash[:error] = 'Unknown resource'
          @token.delete
          render :new and return
        end
      end
      redirect_to @token, notice: 'Token was successfully created with url.'
    else
      render :new
    end
  end
end