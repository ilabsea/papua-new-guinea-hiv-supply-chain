class AddMoreColumnsToOrderLinesTable < ActiveRecord::Migration
  def change
  	add_column :order_lines, :site_suggestion, :decimal
  	add_column :order_lines, :test_kit_waste_acceptable, :decimal 
  	add_column :order_lines, :number_of_client, :integer
  	add_column :order_lines, :consumption_per_client_per_month, :decimal
  	add_column :order_lines, :is_set, :boolean, :default => false
  end
end
