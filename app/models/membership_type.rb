class MembershipType < ActiveRecord::Base
  has_many :membership_requests

  validates_presence_of :name
  validates_inclusion_of :recurring, :autoapprove, in: [true, false]
  validate :recurrence_validation

  def stripe_plan
    Stripe::Plan.retrieve(self.stripe_id)
  end

  def price
    attr = self.read_attribute(:price)
    if not attr and Stripe.api_key
      return self.stripe_plan.amount
    end
    attr
  end

  def recurrence_validation
    if recurring
      price = self.read_attribute(:price)

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

end


