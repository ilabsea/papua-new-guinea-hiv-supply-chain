class AddSystemSuggestionToOrderLines < ActiveRecord::Migration
  def change
    add_column :order_lines, :system_suggestion, :integer
    add_column :order_lines, :suggestion_order, :float
  end
end
