class RemoveColumnHourFromSetting < ActiveRecord::Migration
  def up
  	remove_column :settings, :hour
  end

  def down
  	add_column :settings, :hour, :float
  end
end
