class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :state, index: true, foreign_key: true
      t.references :membership, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
