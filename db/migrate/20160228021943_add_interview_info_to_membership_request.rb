class AddInterviewInfoToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :interview_book_info, :text
  end
end
