class RenameColumnNameOnTableImportSurv < ActiveRecord::Migration
  def up
  	rename_column :import_survs, :name, :form
  end

  def down
  	rename_column :import_survs, :form, :name
  end
end
