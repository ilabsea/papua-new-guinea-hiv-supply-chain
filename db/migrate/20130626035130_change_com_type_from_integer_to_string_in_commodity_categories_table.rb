class ChangeComTypeFromIntegerToStringInCommodityCategoriesTable < ActiveRecord::Migration
  def up
  	change_column :commodity_categories, :com_type, :string
  end

  def down
  	change_column :commodity_categories, :com_type, :integer
  end
end
