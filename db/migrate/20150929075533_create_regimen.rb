class CreateRegimen < ActiveRecord::Migration
  def change
    create_table :regimen do |t|
      t.string :name
      t.references :regimen_category
      t.references :unit
      t.string :strength_dosage

      t.timestamps
    end
    add_index :regimen, :regimen_category_id
    add_index :regimen, :unit_id
  end
end
