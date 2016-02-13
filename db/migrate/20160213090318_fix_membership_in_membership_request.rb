class FixMembershipInMembershipRequest < ActiveRecord::Migration
  def change
    remove_column :membership_requests, :membership_id
    add_reference :membership_requests, :membership_type, index: true, foreign_key: true
  end

end
