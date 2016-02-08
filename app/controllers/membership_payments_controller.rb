class MembershipPaymentsController < ApplicationController
  protect_from_forgery :except => :stripe_webhook

  require 'json'

  def stripe_webhook
    event = JSON.parse(request.body.read)
    if params[:type] == 'customer.subscription.deleted'
      deleted_user = User.find_by(stripe_subscription_id: params[:data][:object][:id])
      if deleted_user.nil?
        return
      end
      deleted_user.stripe_subscription_id = nil
      deleted_user.latest_request.fire_state_event(:cancel)
      deleted_user.save
    end
    status 200
  end

  def pay_single
    @membership_type = MembershipType.find_by(id: params[:type_id])
    if @membership_type == nil or @membership_type.recurring or not current_user.latest_request.check_transition(:paid)
      render nil, status: 500
    else
      # TODO: check if they are eligible to pay the membership type
    end
  end

  def capture_single
    membership_type = MembershipType.find_by(id: params[:type_id])
    token = params[:stripeToken]
    stripe_email = params[:stripeEmail]
    if membership_type == nil or token == nil or stripe_email == nil or !membership_type.recurring
      render nil, status: 500
      return
    end
    begin
      charge = Stripe::Charge.create(
          :amount => membership_type.price,
          :currency => 'aud',
          :source => token,
          :description => current_user.email
      )
      current_user.latest_request.fire_state_event(:paid)
      current_user.save
      redirect_to payment_confirmation, type_id: params[:type_id]
    rescue => e
      flash[:error] = 'Error charging supplied card.'
      current_user.latest_request.fire_state_event(:payment_failed)
      current_user.save
      redirect_to pay_single, type_id: params[:type_id]
    end
  end

  def payment_confirmation
  end

  def capture_subscription
    membership_type = MembershipType.find_by(id: params[:type_id])
    token = params[:stripeToken]
    stripe_email = params[:stripeEmail]
    if membership_type == nil or token == nil or stripe_email.nil? or !membership_type.recurring
      render nil, status: 500
      return
    end
    begin
      current_user.ensure_customer!(token, stripe_email)
    rescue => e
      flash[:error] = 'Error with your details. Please make sure they are correct.'
      redirect_to start_subscription, type_id: params[:type_id]
      return
    end
    current_user.set_subscription!(membership_type.stripe_id)
    current_user.latest_request.fire_state_event(:paid)
    current_user.save
    redirect_to url_for(:controller => :dashboard, :action => :dashboard)
  end

  def start_subscription
    @membership_type = MembershipType.find_by(id: params[:type_id])
    if @membership_type == nil or !@membership_type.recurring or current_user.state?(:payment_required) or not current_user.latest_request.check_transition(:paid)
      render nil, status: 500
    else
      # TODO: check if they are eligible to start the membership
    end
  end

  def cancel_subscription
  end

  def process_cancel_subscription
    if current_user.has_subscription?
      current_user.delete_current_subscription
      current_user.latest_request.fire_state_event(:cancel)
      current_user.save
    end
    redirect_to url_for(:controller => :dashboard, :action => :dashboard)
  end
end
