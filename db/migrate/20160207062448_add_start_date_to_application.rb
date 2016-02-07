class AddStartDateToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :start_date, :date
  end
end
