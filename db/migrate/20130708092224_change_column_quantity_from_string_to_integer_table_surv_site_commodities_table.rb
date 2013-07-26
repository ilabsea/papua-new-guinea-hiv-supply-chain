class ChangeColumnQuantityFromStringToIntegerTableSurvSiteCommoditiesTable < ActiveRecord::Migration
  def up
  	change_column :surv_site_commodities , :quantity, :integer, :default => 0
  end

  def down
  	change_column :surv_site_commodities, :quantity, :string
  end
end
