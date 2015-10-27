class ModifyColumnsSites < ActiveRecord::Migration
  def up
    remove_column :sites, :lat
    remove_column :sites, :lng

    add_column :sites, :town, :string
    add_column :sites, :region, :string
  end

  def down
    add_column :sites, :lat, :float
    add_column :sites, :lng, :float

    remove_column :sites, :town
    remove_column :sites, :region
  end
end
