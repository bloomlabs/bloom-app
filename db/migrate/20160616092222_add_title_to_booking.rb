class AddTitleToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :title, :string
  end
end
