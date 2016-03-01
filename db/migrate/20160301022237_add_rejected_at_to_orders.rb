class AddRejectedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rejected_at, :datetime
    add_column :orders, :unrejected_at, :datetime
  end
end
