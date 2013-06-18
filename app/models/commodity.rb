class Commodity < ActiveRecord::Base
  attr_accessible :commodity_category_id, :consumption_per_client_pack, :consumption_per_client_unit, :name,
  				  :unit_id, :strength_dosage, :abbreviation, :quantity_per_packg	

  belongs_to :commodity_category
  belongs_to :unit

  validates :commodity_category_id, :name ,
  			:unit_id, :strength_dosage, :abbreviation, :quantity_per_packg , :presence   =>  true
end
