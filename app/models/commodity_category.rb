class CommodityCategory < ActiveRecord::Base
  attr_accessible :name

  has_many :commodities

  def self.names
		cats = CommodityCategory.all
		arr = []
		cats.each do |el|
			arr << [el.name, el.id]
		end
		return arr
	end
end
