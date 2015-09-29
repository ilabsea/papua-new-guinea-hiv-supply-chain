class CreateLabTests < ActiveRecord::Migration
  def change
    create_table :lab_tests do |t|
      t.string :name
      t.references :lab_test_category
      t.references :unit

      t.timestamps
    end
    add_index :lab_tests, :lab_test_category_id
    add_index :lab_tests, :unit_id
  end
end
