class ChangeOrderFrequencyToFloatSites < ActiveRecord::Migration
  def up
    change_column :sites, :order_frequency, :float
    change_column :order_lines, :order_frequency, :float
  end

  def down
    change_column :sites, :order_frequency, :integer
    change_column :order_lines, :order_frequency, :integer
  end
end
