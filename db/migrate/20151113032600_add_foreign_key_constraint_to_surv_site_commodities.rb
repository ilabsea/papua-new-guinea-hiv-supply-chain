class AddForeignKeyConstraintToSurvSiteCommodities < ActiveRecord::Migration
  def change
    add_foreign_key :surv_site_commodities, :surv_sites
    add_foreign_key :surv_site_commodities, :commodities
  end
end
