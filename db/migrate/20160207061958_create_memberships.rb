class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :name
      t.integer :price
      t.boolean :recurring
      t.text :expiry

      t.timestamps null: false
    end
  end
end
