class AddResponseMessageToSiteMessages < ActiveRecord::Migration
  def change
    add_column :site_messages, :response_message, :string
  end
end
