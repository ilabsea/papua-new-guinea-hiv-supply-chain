class AddOrderNumberToRequisitionReports < ActiveRecord::Migration
  def change
    add_column :requisition_reports, :order_number, :string, limit: 10
    add_index :requisition_reports, :order_number
  end
end
