class BookingAccessTokenResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :booking_access_token
  has_many :user_booking_access_tokens, through: :booking_access_token
end
