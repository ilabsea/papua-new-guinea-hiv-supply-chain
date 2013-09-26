class AddShipmentsCountToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :site_messages_count, :integer, :default => 0
  end
end
