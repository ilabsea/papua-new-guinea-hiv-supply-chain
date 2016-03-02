class AddColumnApprovedAtAndApprovedUser < ActiveRecord::Migration
  def change
    add_column :orders, :approved_at, :datetime
    add_column :orders, :approved_user_id, :integer, index: true
  end
end
