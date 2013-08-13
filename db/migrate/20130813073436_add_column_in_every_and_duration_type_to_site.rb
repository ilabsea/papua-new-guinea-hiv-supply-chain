class AddColumnInEveryAndDurationTypeToSite < ActiveRecord::Migration
  def change
    add_column :sites, :in_every, :integer
    add_column :sites, :duration_type, :string
  end
end
