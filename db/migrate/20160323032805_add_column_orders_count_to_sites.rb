class AddColumnOrdersCountToSites < ActiveRecord::Migration
  def change
    add_column :sites, :orders_count, :integer, default: 0
  end
end
