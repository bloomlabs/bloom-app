class AddStripeSubscriptionIdToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :stripe_subscription_id, :string
  end
end
