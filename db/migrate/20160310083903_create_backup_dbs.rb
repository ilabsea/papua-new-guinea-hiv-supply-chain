class CreateBackupDbs < ActiveRecord::Migration
  def change
    create_table :backup_dbs do |t|
      t.string :file

      t.timestamps
    end
  end
end
