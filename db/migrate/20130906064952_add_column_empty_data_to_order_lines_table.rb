class AddColumnEmptyDataToOrderLinesTable < ActiveRecord::Migration
  def change
    add_column :order_lines, :order_empty, :boolean, :default => true
  end
end
