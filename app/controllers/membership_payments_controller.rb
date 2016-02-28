class MembershipPaymentsController < ApplicationController
  protect_from_forgery :except => :stripe_webhook
  before_action :set_membership_request, except: [:stripe_webhook, :process_cancel_subscription]
  before_action :authenticate_user!

  require 'json'

  def stripe_webhook
    event = JSON.parse(request.body.read)
    begin
      Stripe::Event.retrieve(:id => event.id)
    rescue => e
      status 500 and return
    end
    if params[:type] == 'customer.subscription.deleted'
      deleted_request = MembershipRequest.find_by(stripe_subscription_id: params[:data][:object][:id])
      if deleted_request.nil?
        return
      end
      deleted_request.delete_subscription
      deleted_request.cancel!
      deleted_request.save
      # TODO: chargebacks!
    end
    status 200
  end

  def capture_single
    membership_type = @membership_request.membership_type
    token = params[:stripeToken]

    if membership_type.recurring or
        @membership_request.current_state != :payment_required

      render json: nil, status: 500 # TODO: Do this property
    end

    begin
      Stripe::Charge.create(
          amount: membership_type.price,
          currency: 'aud',
          source: token,
          description: @membership_request.user.email
      )

      @membership_request.pay!

    rescue => e
      flash[:error] = 'Error charging supplied card.'
      puts e
    end

    redirect_to membership_request_path(@membership_request.id)
  end

  def payment_confirmation
  end

  def capture_subscription
    membership_type = @membership_request.membership_type
    user = @membership_request.user

    token = params[:stripeToken]

    if !membership_type.recurring or
        @membership_request.current_state != :payment_required

      render json: nil, status: 500
      return
    end

    begin
      user.ensure_customer!(token)
    rescue => e
      puts e
      flash[:error] = 'Error with your details. Please make sure they are correct.'.freeze
      redirect_to membership_request_path(@membership_request.id)
      return
    end

    @membership_request.set_subscription!(user.stripe_customer, membership_type.stripe_id)
    @membership_request.pay!
    @membership_request.save

    redirect_to membership_request_path(membership_request)
  end

  def cancel_subscription
  end

  def process_cancel_subscription
    membership_request = MembershipRequest.find_by!(id: params[:application_id])
    if not membership_request.closed?
      membership_request.delete_subscription
      membership_request.cancel!
      membership_request.save
    end
    redirect_to membership_request_path(membership_request)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_membership_request
    @membership_request = MembershipRequest.find(params[:membership_request_id])
  end
end
