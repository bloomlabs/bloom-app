class AddPricingCentsMemberToResource < ActiveRecord::Migration
  def change
    add_column :resources, :pricing_cents_member, :integer
  end
end
