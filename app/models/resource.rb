class Resource < ActiveRecord::Base
  has_many :bookings

  def calculate_booked_week_time(user)
    week_bookings = Booking.joins(:resource).where(["user_id = ? and date >= ? and resource.group = ?", user.id, Date.today.at_beginning_of_week, self.group])
    nhours = 0
    for booking in week_bookings
      nhours += (((booking.time_to - booking.time_from) / 1.hour) * 2).round / 2.0
    end
    nhours
  end
end
