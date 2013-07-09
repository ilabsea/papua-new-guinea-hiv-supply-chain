class ChangeColumnYearFromVarCharToIntegerSurvSitesTable < ActiveRecord::Migration
  def up
  	change_column :surv_sites, :year, :integer
  end

  def down
  	change_column :surv_sites, :year, :string
  end
end
