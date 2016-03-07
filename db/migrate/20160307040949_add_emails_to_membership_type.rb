class AddEmailsToMembershipType < ActiveRecord::Migration
  def change
    add_column :membership_types, :status_email, :string, default: 'memberships@bloom.org.au', null: false
    add_column :membership_types, :success_email, :string, default: 'memberships@bloom.org.au', null: false
  end
end
