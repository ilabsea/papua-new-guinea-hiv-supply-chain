class RenameColumnImportUserToImportUserIdInTableImportSurv < ActiveRecord::Migration
  def up
  	rename_column :import_survs, :import_user, :import_user_id
  end

  def down
  	rename_column :import_survs, :import_user_id, :import_user
  end
end
