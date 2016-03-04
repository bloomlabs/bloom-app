class AddNationalityToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :nationality, :string
  end
end
