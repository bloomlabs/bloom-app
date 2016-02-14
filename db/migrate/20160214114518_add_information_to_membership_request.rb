class AddInformationToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :info, :text
  end
end
