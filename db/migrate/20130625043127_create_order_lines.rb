class CreateOrderLines < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.references :order
      t.references :commodity
      t.integer :stock_on_hand
      t.integer :monthly_use
      t.datetime :earliest_expiry
      t.integer :quantity_system_calculation
      t.integer :quantity_suggested
      t.text :user_data_entry_note
      t.text :user_reviewer_note
      t.string :status

      t.timestamps
    end
    add_index :order_lines, :order_id
    add_index :order_lines, :commodity_id
  end
end
