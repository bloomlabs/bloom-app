class CreateMembershipTypes < ActiveRecord::Migration
  def change
    create_table :membership_types do |t|
      t.string :name
      t.integer :price
      t.boolean :recurring
      t.boolean :autoapprove

      t.timestamps null: false
    end
  end
end
