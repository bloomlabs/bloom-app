class ChangeUserProfileCurrentDegreeToUniversityDegree < ActiveRecord::Migration
  def change
    rename_column :user_profiles, :current_degree, :university_degree
  end
end
