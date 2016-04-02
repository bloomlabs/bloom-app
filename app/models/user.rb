require 'zxcvbn'

class User < ActiveRecord::Base
  has_paper_trail

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  # confirmable - confirm account through emails

  has_many :membership_requests
  has_many :user_profiles

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    newly_created = false
    unless user
      user = User.create(
          firstname: data['first_name'],
          lastname: data['last_name'],
          email: data['email'],
          password: Devise.friendly_token[0, 20]
      )
      newly_created = true
    end

    [user, newly_created]
  end

  validates :firstname, presence: true, length: {in: 2..35}
  validates :lastname, presence: true, length: {in: 2..35}
  validates :access_level, presence: true
  validates :wifi_password, length: {maximum: 35}
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
      pwstrength = Zxcvbn.test(wifi_password, ['bloom', firstname, lastname, email])
      unless pwstrength.score >= 2
        errors.add(:wifi_password, "wifi password must have a strength score of #{strength_str[2]} or above (current score: #{strength_str[pwstrength.score]})")
      end
    end
  end

  def has_subscription?
    !self.stripe_customer_id.nil? and latest_request.has_subscription
  end

  def latest_request
    membership_requests.order(created_at: :desc).first
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
    self.access_level >= 100
  end

  def superuser?
    self.access_level >= 255
  end

  def wifi_access?
    staff? || superuser? || has_subscription?
  end

  def access_level_enum
    [
        ['Normal User', 0],
        ['Staff Member', 100],
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
      fields :email, :user_profiles, :access_level, :stripe_customer_id do
        visible do
          bindings[:view]._current_user.superuser?
        end
      end
    end
  end
end
