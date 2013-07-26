class AddCounterCacheSurvSiteCommoditiesInTableSurvSites < ActiveRecord::Migration
  def up
  	add_column :surv_sites, :surv_site_commodities_count, :integer, :default => 0
  end

  def down
  	remove_column :surv_sites, :surv_site_commodities_count
  end
end
