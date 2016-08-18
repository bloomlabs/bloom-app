class CreateBookingAccessTokens < ActiveRecord::Migration
  def change
    create_table :booking_access_tokens do |t|
      t.string :token
      t.integer :discount
      t.date :expiry
      t.date :signup_expiry

      t.timestamps null: false
    end
  end
end
