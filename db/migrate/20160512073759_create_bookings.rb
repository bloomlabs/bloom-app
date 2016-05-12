class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :resource, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :day
      t.time :time_from
      t.time :time_to
      t.string :stripe_payment_id

      t.timestamps null: false
    end
  end
end
