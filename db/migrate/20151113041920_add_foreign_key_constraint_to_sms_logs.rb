class AddForeignKeyConstraintToSmsLogs < ActiveRecord::Migration
  def change
    add_foreign_key :sms_logs, :sites
    add_foreign_key :sms_logs, :shipments
  end
end
