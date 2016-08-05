class AddChargeCentsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :charge_cents, :integer
  end
end
