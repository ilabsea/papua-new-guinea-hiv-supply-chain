class AddHourToSetting < ActiveRecord::Migration
  def change
  	add_column :settings, :hour, :float
  end
end
