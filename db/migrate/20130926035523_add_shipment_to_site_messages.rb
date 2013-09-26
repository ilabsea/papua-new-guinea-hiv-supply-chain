class AddShipmentToSiteMessages < ActiveRecord::Migration
  def change
    add_column :site_messages, :shipment_id, :integer
  end
end
