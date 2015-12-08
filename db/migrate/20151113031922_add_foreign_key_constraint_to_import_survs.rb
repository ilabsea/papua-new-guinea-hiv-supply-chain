class AddForeignKeyConstraintToImportSurvs < ActiveRecord::Migration
  def change
    add_foreign_key :import_survs, :users
  end
end
