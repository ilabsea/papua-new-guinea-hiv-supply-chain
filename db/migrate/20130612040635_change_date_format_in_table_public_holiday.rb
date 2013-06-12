class ChangeDateFormatInTablePublicHoliday < ActiveRecord::Migration
  def up
  	change_column :public_holidays, :date, :date
  end

  def down
		change_column :public_holidays, :date, :datetime
  end
end
