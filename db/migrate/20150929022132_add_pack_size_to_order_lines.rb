class AddPackSizeToOrderLines < ActiveRecord::Migration
  def change
    add_column :order_lines, :pack_size, :float, default: 1
  end
end
