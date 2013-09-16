class AddColumnSmsAlertToSites < ActiveRecord::Migration
  def change
    add_column :sites, :sms_alerted, :integer, :default => 0
  end
end
