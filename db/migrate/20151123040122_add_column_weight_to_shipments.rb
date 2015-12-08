class AddColumnWeightToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :weight, :float
  end
end
