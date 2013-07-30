class RenameColumnImportUserIdToUserIdInImportSurvsTable < ActiveRecord::Migration
  def up
  	rename_column :import_survs, :import_user_id, :user_id 
  end

  def down
  	rename_column :import_survs,  :user_id, :import_user_id
  end
end
