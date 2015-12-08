class AddForeignKeyConstraintToUsers < ActiveRecord::Migration
  def up
    add_foreign_key :users, :sites
  end

  def down
    remove_foreign_key :users, :sites
  end
end
