class DenormalizeColumnSurvTypeToSurvSiteTable < ActiveRecord::Migration
  def up
  	change_column :import_survs, :surv_type, :string
  	add_column :surv_sites, :surv_type, :string
  end

  def down
  	change_column :import_survs, :surv_type, :integer
  	remove_column :surv_sites, :surv_type
  end
end
