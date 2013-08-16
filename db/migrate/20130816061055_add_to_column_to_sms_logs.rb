class AddToColumnToSmsLogs < ActiveRecord::Migration
  def change
    add_column :sms_logs, :to, :string
  end
end
