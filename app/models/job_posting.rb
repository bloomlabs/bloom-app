class JobPosting < ActiveRecord::Base
  belongs_to :user
  validate do |job_posting|
    if job_posting.expiry <= Date.today
      job_posting.errors[:expiry] = 'Must expire in the future'
    end
  end

  def allows_editing(user)
     !user.nil? and (user.id == self.user_id or user.manager?)
  end
end
