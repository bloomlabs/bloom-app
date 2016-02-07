class MembershipType < ActiveRecord::Base
  has_many :membership_requests
end
