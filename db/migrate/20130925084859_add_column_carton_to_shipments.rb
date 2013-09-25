class AddColumnCartonToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :carton, :integer
  end
end
