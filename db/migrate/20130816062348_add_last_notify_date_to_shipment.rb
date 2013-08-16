class AddLastNotifyDateToShipment < ActiveRecord::Migration
  def change
    add_column :shipments, :last_notified_date, :datetime
  end
end
