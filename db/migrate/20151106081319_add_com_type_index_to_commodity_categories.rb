class AddComTypeIndexToCommodityCategories < ActiveRecord::Migration
  def change
    add_index :commodity_categories, :com_type
  end
end
