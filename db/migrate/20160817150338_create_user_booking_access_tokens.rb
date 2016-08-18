class CreateUserBookingAccessTokens < ActiveRecord::Migration
  def change
    create_table :user_booking_access_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.references :booking_access_token, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
