class AddSiteMessagesCountToSites < ActiveRecord::Migration
  def change
    add_column :sites, :site_messages_count, :integer, :default => 0
  end
end
