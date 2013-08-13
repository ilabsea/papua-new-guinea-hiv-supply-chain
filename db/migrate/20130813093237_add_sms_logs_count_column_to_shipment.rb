class AddSmsLogsCountColumnToShipment < ActiveRecord::Migration
  def change
    add_column :shipments, :sms_logs_count, :integer, :default => 0
    add_column :shipments, :shipment_lines_count, :integer, :default => 0
  end
end
