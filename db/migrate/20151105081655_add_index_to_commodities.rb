class AddIndexToCommodities < ActiveRecord::Migration
  def up
    change_table :commodities do |t|
      t.change :name, 'char(50)'
    end
    add_index :commodities, :name
  end

  def down
    remove_index :commodities, :name
    change_table :commodities do |t|
      t.change :name, :string
    end
    
  end
end
