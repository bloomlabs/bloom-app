class MembershipRequest < ActiveRecord::Base
  include Workflow
  scope :pending_decision, -> { where(workflow_state: 'pending_decision') }

  has_paper_trail

  belongs_to :user
  belongs_to :membership_type

  validates :user_id, presence: true
  validates :membership_type_id, presence: true
  validate :only_one_open_application

  def only_one_open_application
    if MembershipRequest.where(user_id: user_id, closed: false, membership_type_id: membership_type_id).where.not(id: id).count != 0
      errors.add(:base, "Sorry, it looks like you have already applied to become that type of Bloom member. If you think this is a mistake, please <a href='mailto:#{Rails.configuration.x.help_contact.email}'>email #{Rails.configuration.x.help_contact.name}</a>.")
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

  def has_subscription?
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

  def can_cancel?
    self.current_state.events.include?(:cancel) and self.current_state != :active_membership
  end

  def autoapprove
    puts 'TODO: Autoapprove yay!'
  end

  def book
    MembershipRequestsMailer.delay.new_membership_request(self)
  end

  def accept
    Heap.track 'Membership Request Approved', self.user.heap_identifier, application_membership_type: self.membership_type.stripe_id
  end

  def pay
    MembershipRequestsMailer.delay.coworking_confirmation(self)
    Heap.track 'Membership Request Paid', self.user.heap_identifier, current_membership_type: self.membership_type.stripe_id
  end

  def payment_fail
    puts 'TODO: Uh oh ya messed up'
  end

  def cancel
    Heap.track 'Membership Request Cancelled', self.user.heap_identifier
    update_attribute(:closed, true)

    if self.current_state == :active_membership
      Heap.track 'Active Membership Cancelled', self.user.heap_identifier, current_membership_type: ''
      MembershipRequestsMailer.delay.cancelled_membership(self)
    end
  end

  def expire
    update_attribute(:closed, true)

    puts 'TODO: Expired!!!'
  end

  def reject
    update_attribute(:closed, true)

    MembershipRequestsMailer.delay.request_rejected(self)
  end

  def workflow_state_enum
    self.class.workflow_spec.state_names
  end

  def on_payment_required_entry(*args)
    if self.membership_type.price > 0
      MembershipRequestsMailer.delay.request_accepted(self) # Send payment required email
    else
      self.pay! # If the membership is free, we skip the payment required phase
    end
  end

  rails_admin do
    list do
      scopes [nil, :pending_decision]
      sort_by :user
      field :user do
        sortable 'firstname, lastname'
      end
      field :membership_type
      field :workflow_state
    end
    show do
      field :user
      field :membership_type
      field :workflow_state
      field :info
      field :startdate
      field :interview_book_info
      field :cancel_reason
      field :created_at
    end
  end
end
