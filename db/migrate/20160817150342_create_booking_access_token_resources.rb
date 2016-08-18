class CreateBookingAccessTokenResources < ActiveRecord::Migration
  def change
    create_table :booking_access_token_resources do |t|
      t.references :resource, index: true, foreign_key: true
      t.references :booking_access_token, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
