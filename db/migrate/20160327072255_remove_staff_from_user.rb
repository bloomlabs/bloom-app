class RemoveStaffFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :staff, :boolean
  end
end
