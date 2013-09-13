class AddTypeGuidToSmsLogs < ActiveRecord::Migration
  def change
  	add_column :sms_logs, :sms_type, :string
  	add_column :sms_logs, :guid, :string
  	add_column :sms_logs, :status, :string
  end
end
