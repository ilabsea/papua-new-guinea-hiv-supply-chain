class AddPackSizeToCommodities < ActiveRecord::Migration
  def change
    add_column :commodities, :pack_size, :float
  end
end
