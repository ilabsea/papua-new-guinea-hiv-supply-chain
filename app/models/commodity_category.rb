class CommodityCategory < ActiveRecord::Base
  attr_accessible :name

  has_many :commodities
end
