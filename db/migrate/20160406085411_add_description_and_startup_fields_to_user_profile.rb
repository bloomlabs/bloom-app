class AddDescriptionAndStartupFieldsToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :user_description, :string
    add_column :user_profiles, :primary_startup_name, :string
    add_column :user_profiles, :primary_startup_description, :string
  end
end
