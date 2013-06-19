class CommodityCategory < ActiveRecord::Base
  attr_accessible :name, :com_type
  has_many :commodities

  TYPES_DRUG = 1
  TYPES_KIT  = 2

  TYPES = [ ["Drug", TYPES_DRUG], ["Kit" , TYPES_KIT] ]


  def display_type
  	CommodityCategory::TYPES.each do |category_type|
  	   return category_type[0]	 if category_type[1] == com_type
  	end
  	return ""
  end

  def self.drug
  	where( " com_type = #{CommodityCategory::TYPES_DRUG}" )
  end

  def self.kit
  	where( " com_type = #{CommodityCategory::TYPES_KIT}" )
  end

end
