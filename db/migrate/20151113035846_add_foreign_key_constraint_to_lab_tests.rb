class AddForeignKeyConstraintToLabTests < ActiveRecord::Migration
  def change
    add_foreign_key :lab_tests, :lab_test_categories
    add_foreign_key :lab_tests, :units
  end
end
