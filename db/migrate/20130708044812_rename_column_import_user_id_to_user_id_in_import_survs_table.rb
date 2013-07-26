class RenameColumnImportUserIdToUserIdInImportSurvsTable < ActiveRecord::Migration
  def up
  	rename_column :import_survs, :import_user, :user_id 
  end

  def down
  	rename_column :import_survs,  :user_id, :import_user
  end
end
