class CreateInterviewerSchedules < ActiveRecord::Migration
  def change
    create_table :interviewer_schedules do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :day
      t.time :available_time_from
      t.time :available_time_to

      t.timestamps null: false
    end
  end
end
