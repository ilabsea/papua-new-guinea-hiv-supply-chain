class AddMaxNumberOfDeadlineAlertToSites < ActiveRecord::Migration
  def change
    add_column :sites, :max_alert_deadline, :integer, default: 3
  end
end
