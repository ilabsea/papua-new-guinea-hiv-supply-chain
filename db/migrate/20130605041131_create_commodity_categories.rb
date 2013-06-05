class CreateCommodityCategories < ActiveRecord::Migration
  def change
    create_table :commodity_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
