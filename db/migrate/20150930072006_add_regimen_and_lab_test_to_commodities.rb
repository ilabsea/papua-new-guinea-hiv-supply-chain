class AddRegimenAndLabTestToCommodities < ActiveRecord::Migration
  def change
    add_column :commodities, :regimen_id, :integer
    add_column :commodities, :lab_test_id, :integer
  end
end
