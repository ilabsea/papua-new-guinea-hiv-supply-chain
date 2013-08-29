class AddReceivedDateLostDateToShipmentsTable < ActiveRecord::Migration
  def change
    add_column :shipments, :lost_date, :datetime, :default => Time.now
  end
end
