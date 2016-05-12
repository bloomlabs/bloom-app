class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :pricing_cents
      t.string :google_calendar_id

      t.timestamps null: false
    end
  end
end
