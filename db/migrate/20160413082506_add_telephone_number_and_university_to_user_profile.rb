class AddTelephoneNumberAndUniversityToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :telephone_number, :string
    add_column :user_profiles, :university, :string
  end
end
