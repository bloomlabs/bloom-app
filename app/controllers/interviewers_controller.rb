class InterviewersController < ApplicationController
  before_action :authenticate_user!

  def edit_schedule
    @current_availability = InterviewerSchedule.where("user_id=#{current_user.id}")
  end

  def save_schedule
    InterviewerSchedule.delete_all("user_id = #{current_user.id}")
    ActiveSupport::JSON.decode(params[:availability]).each do |item|
      InterviewerSchedule.create(
          user_id: current_user.id,
          day: item['day'],
          available_time_from: Time.zone.local_to_utc(Time.strptime(item['startTime'], '%H:%M')),
          available_time_to: Time.zone.local_to_utc(Time.strptime(item['endTime'], '%H:%M'))
      )
    end
    redirect_to 'edit_schedule'
  end

  def schedule_interview
  end
end
