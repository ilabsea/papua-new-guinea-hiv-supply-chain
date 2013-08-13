class AddSmsLogsTable < ActiveRecord::Migration
  def change
  	create_table :sms_logs do |t|
  		t.string :message
  		t.references :shipment
  		t.references :site
  		t.timestamps
  	end
  end
end
