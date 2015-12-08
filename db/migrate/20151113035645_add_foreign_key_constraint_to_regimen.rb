class AddForeignKeyConstraintToRegimen < ActiveRecord::Migration
  def change
    add_foreign_key :regimen, :regimen_categories
    add_foreign_key :regimen, :units
  end
end
