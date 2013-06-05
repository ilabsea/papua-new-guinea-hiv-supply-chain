class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.string :name
      t.integer :commodity_category_id
      t.integer :consumption_per_client_pack
      t.integer :consumption_per_client_unit

      t.timestamps
    end
  end
end
