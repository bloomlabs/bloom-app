class AddClosedToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :closed, :boolean, default: false
  end
end
