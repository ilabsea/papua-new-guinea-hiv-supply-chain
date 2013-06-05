class CreatePublicHolidays < ActiveRecord::Migration
  def change
    create_table :public_holidays do |t|
      t.string :name
      t.datetime :date

      t.timestamps
    end
  end
end
