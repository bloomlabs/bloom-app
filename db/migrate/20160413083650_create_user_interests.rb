class CreateUserInterests < ActiveRecord::Migration
  def change
    create_table :user_interests do |t|
      t.references :user_profile, index: true, foreign_key: true
      t.string :interest

      t.timestamps null: false
    end
  end
end
