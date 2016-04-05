require 'zxcvbn'

class User < ActiveRecord::Base
  has_paper_trail
  has_secure_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable, :omniauth_providers => [:google_oauth2]

  has_many :membership_requests
  has_many :user_profiles

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    newly_created = false
    unless user
      user = User.new(
          firstname: data['first_name'],
          lastname: data['last_name'],
          email: data['email'],
          provider: access_token.provider,
          uid: access_token.uid,
          password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
      newly_created = true
    end

    unless user.confirmed?
      user.skip_confirmation!
      user.save
    end

    [user, newly_created]
  end

  validates :firstname, presence: true, length: {in: 2..35}
  validates :lastname, presence: true, length: {in: 2..35}
  validates :access_level, presence: true
  validates :wifi_password, length: {maximum: 253}
  validates :email, length: {maximum: 200}
  validate :wifi_password_strength

  def strength_str
    [
    'Very Weak',
    'Weak',
    'Okay',
    'Strong',
    'Very Strong',
    ]
  end


  def wifi_password_strength
    unless wifi_password.blank?
      pwstrength = Zxcvbn.test(wifi_password, ['bloom', 'innovation', 'hub', firstname, lastname, email])
      unless pwstrength.score >= 2
        errors.add(:wifi_password, "must have a strength score of #{strength_str[2]} or above (current score: #{strength_str[pwstrength.score]})")
      end
    end
  end

  def has_subscription?
    !self.stripe_customer_id.nil? and membership_requests.any? {|r| r.has_subscription?}
  end

  def active_memberships
    membership_requests.where(workflow_state: 'active_membership')
  end

  def stripe_customer
    Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def ensure_customer!(token)
    if self.stripe_customer_id.nil?
      customer = Stripe::Customer.create(
          :source => token,
          :email => email
      )
      self.stripe_customer_id = customer.id
      save
      customer
    else
      stripe_customer
    end
  end

  def name
    "#{firstname} #{lastname} (#{email})"
  end

  def staff?
    self.access_level >= 50 || (self.email.ends_with?('@bloom.org.au') && self.access_level >= 0)
  end

  def manager?
    self.access_level >= 100
  end

  def superuser?
    self.access_level >= 255
  end

  def wifi_username
    email[0..64] # TODO: Potential for collisions
  end

  def wifi_access?
    self.staff? || self.active_memberships.any? {|r| r.membership_type.wifi_access?}
  end

  def access_level_enum
    [
        ['Not Staff Member (Explicit)', -100],
        ['Normal User', 0],
        ['Staff Member (Explicit)', 50],
        ['Manager', 100],
        ['Superuser', 255],
    ]
  end

  # Use front-end helpers in the model for certain formatting
  def helper
    ActionController::Base.helpers
  end

  rails_admin do
    list do
      sort_by 'firstname asc, users.lastname asc, users.email'
      field :firstname
      field :lastname
      field :email
      field :access_level do
        queryable false
      end
    end
    show do
      field :email
      field :firstname
      field :lastname
      field :user_profiles
      field :membership_requests
      field :access_level
      field :stripe_customer_id
      field :sign_in_count
      field :last_sign_in_at
      field :created_at
      field :updated_at
    end
    edit do
      field :firstname
      field :lastname

      # We restrict editing advanced user attributes to superusers due to potential for breakages
      fields :email, :user_profiles, :access_level, :stripe_customer_id, :password, :wifi_password do
        visible do
          bindings[:view]._current_user.superuser?
        end
      end
    end
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
