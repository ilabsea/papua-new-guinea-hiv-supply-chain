class AddSiteIdToOrderLines < ActiveRecord::Migration
  def change
    add_column :order_lines, :site_id, :integer
  end
end
