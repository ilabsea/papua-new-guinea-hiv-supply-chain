class CreateImportSurvs < ActiveRecord::Migration
  def change
    create_table :import_survs do |t|
      t.integer :surv_type
      t.string :name
      t.integer :import_user

      t.timestamps
    end
  end
end
