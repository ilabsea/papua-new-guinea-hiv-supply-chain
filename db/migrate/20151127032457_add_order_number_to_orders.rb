class AddOrderNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_number, :string, limit: 10
    add_index :orders, :order_number
  end
end
