class AddColumnCartonToSiteMessages < ActiveRecord::Migration
  def change
    add_column :site_messages, :carton, :integer
  end
end
