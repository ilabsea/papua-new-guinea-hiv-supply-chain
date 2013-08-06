class CreateShipmentTables < ActiveRecord::Migration
  def change
  	create_table :shipments do |t|
  		t.string :consignment_number, :limit => 20
  		t.string :status, :limit => 20
  		t.datetime :shipment_date
  		t.datetime :received_date
  		t.references :user
  		t.references :site
  		t.references :order
  		t.timestamps
  	end
  end
end
