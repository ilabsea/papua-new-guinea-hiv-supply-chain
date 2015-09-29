class CreateLabTestCategories < ActiveRecord::Migration
  def change
    create_table :lab_test_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
