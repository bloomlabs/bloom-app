class MembershipRequest < ActiveRecord::Base
  has_paper_trail

  belongs_to :user
  belongs_to :membership_type
end
