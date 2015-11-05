class ChangeColumnOrderFrequencyOrderLines < ActiveRecord::Migration
  def up
    change_column :order_lines, :order_frequency, :integer
  end

  def down
    change_column :order_lines, :order_frequency, :float
  end
end
