class AddForeignKeyConstraintToCommodities < ActiveRecord::Migration
  def change
    add_foreign_key :commodities, :commodity_categories
    add_foreign_key :commodities, :units
    add_foreign_key :commodities, :lab_tests
    add_foreign_key :commodities, :regimen
  end
end
