class CreateSiteMessages < ActiveRecord::Migration
  def change
    create_table :site_messages do |t|
      t.text :message
      t.references :site
      t.string :status
      t.string :consignment_number
      t.string :guid
      t.string :from_phone
      t.integer :error, :default => 0

      t.timestamps
    end
    add_index :site_messages, :site_id
  end
end
