class AddProvinceIdAsForeignKeyInSites < ActiveRecord::Migration
  def up
    add_foreign_key :sites, :provinces
  end

  def down
    remove_foreign_key :sites, :provinces
  end
end
