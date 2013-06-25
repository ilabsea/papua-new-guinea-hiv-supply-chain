class CreateSurvSites < ActiveRecord::Migration
  def change
    create_table :surv_sites do |t|
      t.integer :import_id
      t.integer :site_id
      t.string :month
      t.string :year

      t.timestamps
    end
  end
end
