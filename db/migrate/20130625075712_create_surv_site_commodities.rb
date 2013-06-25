class CreateSurvSiteCommodities < ActiveRecord::Migration
  def change
    create_table :surv_site_commodities do |t|
      t.integer :surv_site_id
      t.integer :commodity_id
      t.string :quantity

      t.timestamps
    end
  end
end
