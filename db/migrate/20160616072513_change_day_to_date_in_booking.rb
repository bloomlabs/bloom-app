class ChangeDayToDateInBooking < ActiveRecord::Migration
  def change
    remove_column :bookings, :day
    add_column :bookings, :book_date, :date
  end
end
