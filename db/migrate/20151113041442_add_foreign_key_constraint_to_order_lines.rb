class AddForeignKeyConstraintToOrderLines < ActiveRecord::Migration
  def change
    add_foreign_key :order_lines, :orders
    add_foreign_key :order_lines, :sites
    add_foreign_key :order_lines, :commodities
  end
end
