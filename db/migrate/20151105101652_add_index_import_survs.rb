class AddIndexImportSurvs < ActiveRecord::Migration
  def up
    add_index :surv_sites, :import_surv_id
    add_index :surv_site_commodities, :surv_site_id
    add_index :surv_site_commodities, :commodity_id
  end

  def down
    remove_index :surv_sites, :import_surv_id
    remove_index :surv_site_commodities, :surv_site_id
    remove_index :surv_site_commodities, :commodity_id
  end
end
