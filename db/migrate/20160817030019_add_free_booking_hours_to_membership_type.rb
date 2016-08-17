class AddFreeBookingHoursToMembershipType < ActiveRecord::Migration
  def change
    add_column :membership_types, :free_booking_hours, :integer
  end
end
