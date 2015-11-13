class AddForeignConstraintToSurvSites < ActiveRecord::Migration
  def change
    add_foreign_key :surv_sites, :sites
  end
end
