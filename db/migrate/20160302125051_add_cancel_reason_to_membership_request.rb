class AddCancelReasonToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :cancel_reason, :text
  end
end
