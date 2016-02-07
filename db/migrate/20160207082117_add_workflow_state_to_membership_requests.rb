class AddWorkflowStateToMembershipRequests < ActiveRecord::Migration
  def change
    add_column :membership_requests, :workflow_state, :string
  end
end
