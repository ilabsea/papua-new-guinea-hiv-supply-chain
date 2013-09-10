class RenameColumnOrderEmptyToInCompletedOrderLines < ActiveRecord::Migration
  def up
  	remove_column :order_lines, :order_empty
  	add_column :order_lines, :completed_order, :integer, :default => 0
  end

  def down
  	add_column :order_lines, :order_empty, :boolean, :default => true
  	remove_column :order_lines, :completed_order 
  end
end
