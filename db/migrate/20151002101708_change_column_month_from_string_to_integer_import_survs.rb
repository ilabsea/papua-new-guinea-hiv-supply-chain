class ChangeColumnMonthFromStringToIntegerImportSurvs < ActiveRecord::Migration
  def up
    change_column :import_survs, :month, :integer
  end

  def down
    change_column :import_survs, :month, :string
  end
end
