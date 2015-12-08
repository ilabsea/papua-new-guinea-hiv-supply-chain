class AddIndexToShipments < ActiveRecord::Migration
  def up
    change_table :shipments do |t|
      t.change :status, 'char(25)'
    end
    add_index :shipments, :status
    add_index :shipments, :cost
    add_index :shipments, :carton
    add_index :shipments, :consignment_number
  end

  def down
    remove_index :shipments, :status
    remove_index :shipments, :cost
    remove_index :shipments, :carton
    remove_index :shipments, :consignment_number

    change_table :shipments do |t|
      t.change :status, :string
    end
  end
end
