class RenameColumnImportIdInTableSurvSites < ActiveRecord::Migration
  def up
  	rename_column :surv_sites, :import_id, :import_surv_id
  end

  def down
  	rename_column :surv_sites, :import_surv_id, :import_id
  end
end
