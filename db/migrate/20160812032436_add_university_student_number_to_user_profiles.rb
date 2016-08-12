class AddUniversityStudentNumberToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles, :university_student_number, :string
  end
end
