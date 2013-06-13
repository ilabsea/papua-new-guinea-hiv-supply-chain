class AddColumnGroupToCommodityCategory < ActiveRecord::Migration
  def change
  	add_column :commodity_categories, :com_type, :integer
  end
end
