class AddForeignKeyConstraintToSiteMessages < ActiveRecord::Migration
  def change
    add_foreign_key :site_messages, :sites
    add_foreign_key :site_messages, :shipments
  end
end
