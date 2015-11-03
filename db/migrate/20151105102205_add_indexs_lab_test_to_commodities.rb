class AddIndexsLabTestToCommodities < ActiveRecord::Migration
  def change
    add_index :commodities, :lab_test_id
    add_index :commodities, :regimen_id
  end
end
