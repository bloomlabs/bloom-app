class Booking < ActiveRecord::Base
  belongs_to :resource_id
  belongs_to :user_id
end
