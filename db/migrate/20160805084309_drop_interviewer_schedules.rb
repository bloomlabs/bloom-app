class DropInterviewerSchedules < ActiveRecord::Migration
  def change
    drop_table :interviewer_schedules
  end
end
