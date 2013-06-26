class CommodityCategory < ActiveRecord::Base
  attr_accessible :name, :com_type
  has_many :commodities

  TYPES_DRUG = 'Drug'
  TYPES_KIT  = 'Kit'

  TYPES = [TYPES_DRUG, TYPES_KIT ]

  def self.drug
  	where "com_type = '#{CommodityCategory::TYPES_DRUG}' " 
  end

  def self.kit
  	where "com_type = '#{CommodityCategory::TYPES_KIT}' " 
  end

end
