class RemoveStudentTypeFromUserProfile < ActiveRecord::Migration
  def change
    remove_column :user_profiles, :student_type
  end
end
