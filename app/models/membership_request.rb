class MembershipRequest < ActiveRecord::Base
  include Workflow

  has_paper_trail

  belongs_to :user
  belongs_to :membership_type

  validates :user_id, presence: true
  validates :membership_type_id, presence: true
  validate :only_one_open_application

  def only_one_open_application
    if MembershipRequest.where(user_id: user_id, closed: false, membership_type_id: membership_type_id).where.not(id: id).count != 0
      errors.add(:base, "you may only have one application per membership type open at a time")
    end
  end

  after_create :autoapprove_check

  # We advance the application to the payment stage if autoapprove is on for the given membership type
  def autoapprove_check
    if membership_type.autoapprove?
      autoapprove!
    end
  end

  def delete_subscription
    stripe_subscription.delete
    self.stripe_subscription_id = nil
  end

  def stripe_subscription
    self.user.stripe_customer.subscriptions.retrieve(self.stripe_subscription_id)
  end

  def has_subscription
    !self.stripe_subscription_id.nil?
  end

  def set_subscription!(customer, plan_id)
    sub = customer.subscriptions.create(
        :plan => plan_id
    )
    self.stripe_subscription_id = sub.id
  end

  workflow do
    state :new do
      event :submit, transitions_to: :book_interview
      event :cancel, transitions_to: :cancelled
      event :autoapprove, transitions_to: :payment_required
    end

    state :book_interview do
      event :book, transitions_to: :pending_decision
      event :cancel, transitions_to: :cancelled
    end

    state :pending_decision do
      event :accept, transitions_to: :payment_required
      event :reject, transitions_to: :rejected
      event :cancel, transitions_to: :cancelled
    end

    state :payment_required do
      event :pay, transitions_to: :active_membership
      event :cancel, transitions_to: :cancelled
    end

    state :active_membership do
      event :payment_fail, transitions_to: :payment_required
      event :expire, transitions_to: :expired
      event :cancel, transitions_to: :cancelled
    end

    state :rejected
    state :cancelled
    state :expired
  end

  def autoapprove
    puts 'TODO: Autoapprove yay!'
  end

  def book
    MembershipRequestsMailer.delay.interview_booked(self.user)
    puts 'TODO: Send pre-interview email'
  end

  def accept
    puts 'TODO: Acceptance email, ask for payment'
  end

  def pay
    puts 'TODO: Yay you\'re a member!'
  end

  def payment_fail
    puts 'TODO: Uh oh ya messed up'
  end

  def cancel
    update_attribute(:closed, true)

    puts 'TODO: Sorry to see you go email'
  end

  def expire
    update_attribute(:closed, true)

    puts 'TODO: Expired!!!'
  end

  def reject
    update_attribute(:closed, true)

    puts 'TODO: Send reject email'
  end

end
