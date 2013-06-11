class AddSiteIdToUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :site_id, :integer, :references => :sites
  end
end
