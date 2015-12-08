class AddPosToCommodities < ActiveRecord::Migration
  def change
    add_column :commodities, :position, :integer, default: 0
    add_index :commodities, :position
    add_index :commodities, [:position, :name]
  end
end
