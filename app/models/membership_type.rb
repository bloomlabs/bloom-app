class MembershipType < ActiveRecord::Base
  has_many :membership_requests

  validates_presence_of :name
  validates_inclusion_of :recurring, :autoapprove, in: [true, false]
  validate :recurrence_validation
  validates :status_email, email: true, presence: true
  validates :success_email, email: true, presence: true
  validate :stripe_plan_exists

  def stripe_plan
    begin
      Stripe::Plan.retrieve(self.stripe_id) if not self.stripe_id.nil?
    rescue Stripe::InvalidRequestError
      nil
    end
  end

  def price
    if self.recurring
      if Stripe.api_key and self.stripe_plan
        self.stripe_plan.amount
      else
        nil
      end
    else
      self.read_attribute(:price)
    end
  end

  def recurrence_validation
    price = self.read_attribute(:price)

    if recurring
      if stripe_id.blank?
        errors.add(:stripe_id, "stripe_id must be set on a recurring model")
      end

      if not price.blank?
        errors.add(:price, "price must not be set on a recurring model")
      end

    else
      if not stripe_id.blank?
        errors.add(:stripe_id, "stripe_id must not be set on a non-recurring model")
      end

      if price.blank?
        errors.add(:price, "price must be set on a non-recurring model")
      end
    end
  end

  def stripe_plan_exists
    if Stripe.api_key and recurring and not stripe_id.blank?
      begin
        Stripe::Plan.retrieve(stripe_id)
      rescue Stripe::InvalidRequestError => e
        errors.add(:stripe_id, "stripe ID does not correspond to existing plan, create the stripe plan before continuing")
      end
    end
  end
end


