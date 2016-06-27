class AddFullNameToResources < ActiveRecord::Migration
  def change
    add_column :resources, :full_name, :string
  end
end
