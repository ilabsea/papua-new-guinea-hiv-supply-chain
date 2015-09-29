class CreateRegimenCategories < ActiveRecord::Migration
  def change
    create_table :regimen_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
