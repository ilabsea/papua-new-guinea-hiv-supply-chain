class RemoveColumnConsumptionFromCommodities < ActiveRecord::Migration
  def up
    remove_column :commodities, :consumption_per_client_pack
    remove_column :commodities, :consumption_per_client_unit
  end

  def down
    add_column :commodities, :consumption_per_client_pack, :integer
    add_column :commodities, :consumption_per_client_unit, :integer
  end
end
