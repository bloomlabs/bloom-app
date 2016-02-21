class CreateMembershipRequests < ActiveRecord::Migration
  def change
    create_table :membership_requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :membership_type, index: true, foreign_key: true
      t.date :startdate

      t.timestamps null: false
    end
  end
end
