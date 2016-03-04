class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :signup_reason
      t.date :date_of_birth
      t.string :gender
      t.string :student_type
      t.string :education_status
      t.string :current_degree
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
