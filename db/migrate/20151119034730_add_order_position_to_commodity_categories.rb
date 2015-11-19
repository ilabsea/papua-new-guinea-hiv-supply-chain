class AddOrderPositionToCommodityCategories < ActiveRecord::Migration
  def change
    add_column :commodity_categories, :pos, :integer, default: 0
  end
end
