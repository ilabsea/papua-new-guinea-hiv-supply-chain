class ChangeColumnsOrderDateAndDateSummittionFromDatetimeToDate < ActiveRecord::Migration
  def up
  	change_column :orders, :order_date, :date
  	remove_column :orders, :date_sumbittion
  	add_column :orders, :date_submittion, :date
  end

  def down
  	change_column :orders, :order_date, :datetime
  	add_column :orders, :date_sumbittion, :datetime
  	remove_column :orders, :date_submittion
  end
end
