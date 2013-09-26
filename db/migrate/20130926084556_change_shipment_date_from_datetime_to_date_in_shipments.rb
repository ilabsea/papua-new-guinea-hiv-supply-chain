class ChangeShipmentDateFromDatetimeToDateInShipments < ActiveRecord::Migration
  def up
  	change_column :shipments, :shipment_date, :date
  end

  def down
  	change_column :shipments, :shipment_date, :datetime
  end
end
