class ChangeColumnMonthFromStringToIntegerSurvSites < ActiveRecord::Migration
  def up
    change_column :surv_sites, :month, :integer
  end

  def down
    change_column :surv_sites, :month, :string
  end
end
