class AddGroupToResources < ActiveRecord::Migration
  def change
    add_column :resources, :group, :string
  end
end
