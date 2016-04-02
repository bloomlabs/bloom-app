class AddWifiPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :wifi_password, :string
  end
end
