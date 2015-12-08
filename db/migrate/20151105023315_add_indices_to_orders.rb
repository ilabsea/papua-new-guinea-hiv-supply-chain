class AddIndicesToOrders < ActiveRecord::Migration

  def up
    change_table :orders do |t|
      t.change :status, 'char(15)'
    end
    
    add_index :orders, [:status, :site_id]
    add_index :orders, :status
    add_index :order_lines, [:order_id, :shipment_status, :completed_order], name: :shippable_index
  end

  def down

    remove_index :order_lines, name: :shippable_index
    remove_index :orders, :status
    remove_index :orders, [:status, :site_id]

    change_table :orders do |t|
      t.change :status, :string
    end
  end
end
