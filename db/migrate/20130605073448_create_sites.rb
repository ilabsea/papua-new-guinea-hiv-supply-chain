class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :service_type
      t.float :suggestion_order
      t.integer :order_frequency
      t.integer :number_of_deadline_sumission
      t.date :order_start_at
      t.float :test_kit_waste_acceptable
      t.text :address
      t.string :contact_name
      t.string :mobile
      t.string :land_line_number
      t.string :email
      t.references :province
      t.timestamps
    end
  end
end
