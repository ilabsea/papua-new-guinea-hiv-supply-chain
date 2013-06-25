class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :site
      t.boolean    :is_requisition_form
      t.datetime   :date_sumbittion
      t.references :user_place_order
      t.datetime   :order_date
      t.references :user_data_entry
      t.datetime   :review_date
      t.references :review_user
      t.string     :status
      t.references :requisition_report
      t.timestamps
    end
    add_index :orders, :site_id
    add_index :orders, :user_place_order_id
    add_index :orders, :user_data_entry_id
    add_index :orders, :requisition_report_id
  end
end
