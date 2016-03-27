class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  # confirmable - confirm account through emails?

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
    self.email
  end

  def staff?
    self.access_level >= 100
  end

  def superuser?
    self.access_level >= 255
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
end
