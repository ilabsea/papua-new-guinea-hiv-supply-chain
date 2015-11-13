class AddForeignKeyConstraintToRequisitionReports < ActiveRecord::Migration
  def change
    add_foreign_key :requisition_reports, :users
    add_foreign_key :requisition_reports, :sites
  end
end
