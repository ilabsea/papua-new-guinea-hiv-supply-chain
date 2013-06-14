class AddMoreColumnsToCommoditiesTable < ActiveRecord::Migration
  def change
  	add_column :commodities, :unit_id, :integer, :references => :units
  	add_column :commodities, :strength_dosage, :string
  	add_column :commodities, :abbreviation, :string
  	add_column :commodities, :quantity_per_packg, :string
  end
end
