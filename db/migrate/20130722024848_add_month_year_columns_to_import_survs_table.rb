class AddMonthYearColumnsToImportSurvsTable < ActiveRecord::Migration
  def change
  	add_column :import_survs, :year, :integer, :limit => 4
  	add_column :import_survs, :month, :string, :limit => 20
  end
end
