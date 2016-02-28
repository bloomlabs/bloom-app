class RemoveStartdateFromMembershipRequest < ActiveRecord::Migration
  def change
    remove_column :membership_requests, :startdate, :date
  end
end
