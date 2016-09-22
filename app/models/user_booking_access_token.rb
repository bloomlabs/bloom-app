class UserBookingAccessToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :booking_access_token
  has_many :booking_access_token_resources, through: :booking_access_token
end
