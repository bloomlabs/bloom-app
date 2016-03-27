class UserProfile < ActiveRecord::Base
  belongs_to :user

  def name
    "#{user.name} @ #{created_at}"
  end
end
