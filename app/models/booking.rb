class Booking < ActiveRecord::Base
  belongs_to :resources
  belongs_to :user
end
