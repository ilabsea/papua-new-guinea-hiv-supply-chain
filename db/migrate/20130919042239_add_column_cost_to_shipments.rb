class AddColumnCostToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :cost, :float
  end
end
