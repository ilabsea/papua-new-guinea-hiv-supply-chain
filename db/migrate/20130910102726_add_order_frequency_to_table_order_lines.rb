class AddOrderFrequencyToTableOrderLines < ActiveRecord::Migration
  def change
    add_column :order_lines, :order_frequency, :float
  end
end
