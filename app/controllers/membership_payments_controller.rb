class MembershipPaymentsController < ApplicationController
  protect_from_forgery :except => :stripe_webhook
  before_action :authenticate_user!

  require 'json'

  def stripe_webhook
    event = JSON.parse(request.body.read)
    if params[:type] == 'customer.subscription.deleted'
      deleted_user = User.find_by(stripe_subscription_id: params[:data][:object][:id])
      if deleted_user.nil?
        return
      end
      deleted_user.stripe_subscription_id = nil
      deleted_user.latest_request.cancel!
      deleted_user.save
      # TODO: chargebacks!
    end
    status 200
  end

  def capture_single
    membership_request = MembershipRequest.find_by!(id: params[:application_id])
    membership_type = membership_request.membership_type
    token = params[:stripeToken]
    stripe_email = params[:stripeEmail]
    if membership_type == nil or token == nil or stripe_email == nil or !membership_type.recurring or membership_request.current_state != :payment_required
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
      membership_request.pay!
      current_user.save
    rescue => e
      flash[:error] = 'Error charging supplied card.'
    end
    redirect_to membership_request_path(membership_request.id)
  end

  def payment_confirmation
  end

  def capture_subscription
    membership_request = MembershipRequest.find_by!(id: params[:application_id])
    membership_type = membership_request.membership_type
    token = params[:stripeToken]
    stripe_email = params[:stripeEmail]
    if membership_type == nil or token == nil or stripe_email.nil? or !membership_type.recurring or current_user.has_subscription? or membership_request.current_state != :payment_required
      render nil, status: 500
      return
    end
    begin
      current_user.ensure_customer!(token, stripe_email)
    rescue => e
      puts e
      flash[:error] = 'Error with your details. Please make sure they are correct.'.freeze
      redirect_to membership_request_path(membership_request.id)
      return
    end
    membership_request.set_subscription!(current_user.stripe_customer, membership_type.stripe_id)
    membership_request.pay!
    membership_request.save
    current_user.save
    redirect_to url_for(:controller => :dashboard, :action => :dashboard)
  end

  def cancel_subscription
  end

  def process_cancel_subscription
    if current_user.has_subscription?
      current_user.delete_current_subscription
      current_user.latest_request.cancel!
      current_user.save
    end
    redirect_to url_for(:controller => :dashboard, :action => :dashboard)
  end
end
