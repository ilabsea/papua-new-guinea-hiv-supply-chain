class AddColumnArvTypeToOrderLines < ActiveRecord::Migration
  def change
  	add_column :order_lines, :arv_type, :string
  end
end
