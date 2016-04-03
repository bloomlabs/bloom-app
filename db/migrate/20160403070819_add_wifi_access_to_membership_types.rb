class AddWifiAccessToMembershipTypes < ActiveRecord::Migration
  def change
    add_column :membership_types, :wifi_access, :boolean, default: false
  end
end
