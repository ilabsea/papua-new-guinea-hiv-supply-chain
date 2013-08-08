class AddShipmentStatusToOrderLinesTable < ActiveRecord::Migration
  def change
  	add_column :order_lines,  :shipment_status, :boolean, :default => 0
  end
end
