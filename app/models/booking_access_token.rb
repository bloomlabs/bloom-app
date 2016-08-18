class BookingAccessToken < ActiveRecord::Base
  has_many :booking_access_token_resources, :dependent => :delete_all
  has_many :user_booking_access_tokens
  validate do |booking_access_token|
    if booking_access_token.expiry < Date.today
      booking_access_token.errors[:expiry] = 'Must expire in the future'
    end
    if booking_access_token.signup_expiry < Date.today
      booking_access_token.errors[:signup_expiry] = 'Must expire in the future'
    end
    if booking_access_token.discount < 0 or booking_access_token.discount > 100
      booking_access_token.errors[:discount] = 'Discount should be a positive percentage'
    end
  end
end
