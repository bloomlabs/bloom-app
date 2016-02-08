class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :membership_requests

  def has_subscription?
    !self.stripe_customer_id.nil? and !self.stripe_subscription_id.nil?
  end

  def latest_request
    membership_requests.order(created_at: :desc).first
  end

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def stripe_subscription
    self.stripe_customer.retrieve(self.stripe_subscription_id)
  end

  def delete_current_subscription
    stripe_subscription.delete
    self.stripe_subscription_id = nil
  end

  def ensure_customer!(token, email)
    if self.stripe_customer_id.nil?
      customer = Stripe::Customer.create(
          :source => token,
          :email => email
      )
      self.stripe_customer_id = customer.id
    end
  end

  def set_subscription!(plan_id)
    if has_subscription?
      sub = stripe_subscription
      sub.plan = plan_id
      sub.save
    else
      sub = Stripe::Subscription.create(
          :plan => plan_id
      )
      self.stripe_subscription_id = sub.id
    end
  end
end
