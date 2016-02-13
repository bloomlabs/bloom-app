class MembershipRequest < ActiveRecord::Base
  include Workflow

  has_paper_trail

  belongs_to :user
  belongs_to :membership_type

  validates :user_id, presence: true
  validates :membership_type_id, presence: true
  validates :startdate, presence: true
  validate :only_one_open_application

  def only_one_open_application
    if MembershipRequest.where(user_id: user_id, closed: false, membership_type_id: membership_type_id).count != 0
      errors.add(:base, "you may only have one application per membership type open at a time")
    end
  end

  workflow do
    state :new do
      event :submit, transitions_to: :book_interview
      event :cancel, transitions_to: :cancelled
    end

    state :book_interview do
      event :booked, transitions_to: :pending_decision
      event :cancel, transitions_to: :cancelled
    end

    state :pending_decision do
      event :accept, transitions_to: :payment_required
      event :reject, transitions_to: :rejected
      event :cancel, transitions_to: :cancelled
    end

    state :payment_required do
      event :paid, transitions_to: :current
      event :cancel, transitions_to: :cancelled
    end

    state :current do
      event :payment_failed, transitions_to: :payment_required
      event :expired, transitions_to: :expired
      event :cancel, transitions_to: :cancelled
    end

    state :rejected
    state :cancelled
    state :expired
  end

  def booked
    puts 'TODO: Send pre-interview email'
  end

  def cancel
    puts 'TODO: Sorry to see you go email'
  end

  def accept
    puts 'TODO: Acceptance email, ask for payment'
  end

  def paid
    puts 'TODO: Yay you\'re a member!'
  end

  def payment_failed
    puts 'TODO: Uh oh ya messed up'
  end

  def expired
    self.closed = true
    puts 'TODO: Expired!!!'
  end

  def reject
    self.closed = true
    puts 'TODO: Send reject email'
  end

  def cancelled
    self.closed = true
  end

end
