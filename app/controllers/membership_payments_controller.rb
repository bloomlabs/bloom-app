class MembershipPaymentsController < ApplicationController
  protect_from_forgery :except => :stripe_webhook

  require "json"

  def stripe_webhook
    event = JSON.parse(request.body.read)
    if params[:type] == 'customer.subscription.deleted'
      # TODO
    end
    status 200
  end

  def pay_single
    @membership_type = MembershipType.find_by(id: params[:type_id])
    if @membership_type == nil or @membership_type.recurring
      render nil, status: 500
      return
    else
      # TODO: check if they are eligible to pay the membership type
    end
  end

  def capture_subscription
    membership_type = MembershipType.find_by(id: params[:type_id])
    token = params[:stripeToken]
    stripe_email = params[:stripeEmail]
    if membership_type == nil or token == nil or stripe_email == nil or !membership_type.recurring
      render nil, status: 500
      return
    end
    customer = Stripe::Customer.create(
        :source => token,
        :plan => membership_type.stripe_id,
        :email => stripe_email
    )
    redirect_to :d
  end

  def start_subscription
    @membership_type = MembershipType.find_by(id: params[:type_id])
    if @membership_type == nil or !@membership_type.recurring
      render nil, status: 500
    else
      # TODO: check if they are eligible to start the membership
    end
  end

  def cancel_subscription
  end
end
