class CreateRequisitionReports < ActiveRecord::Migration
  def change
    create_table :requisition_reports do |t|
      t.string :form
      t.references :site
      t.references :user
      t.string :status, :default => RequisitionReport::IMPORT_STATUS_PENDING
      t.timestamps
    end
  end
end
