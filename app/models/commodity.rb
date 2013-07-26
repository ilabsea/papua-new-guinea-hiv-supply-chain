class Commodity < ActiveRecord::Base

  attr_accessor :commodity_type

  attr_accessible :commodity_category_id, :consumption_per_client_pack, :consumption_per_client_unit, :name,
  				  :unit_id, :strength_dosage, :abbreviation, :quantity_per_packg	

  belongs_to :commodity_category
  belongs_to :unit

  validates :commodity_category_id, :name ,	:unit_id, :presence   =>  true
  validates :name , :uniqueness => true
  validate :validate_commodity_type

  default_scope order("commodities.name ASC")

  def validate_commodity_type
  	if (self.commodity_type == "drugs")
  		errors.add(:strength_dosage, "can't be blank") if self.strength_dosage.empty?
  		errors.add(:abbreviation, "can't be blank") if self.abbreviation.empty?
  		errors.add(:quantity_per_packg, "can't be blank") if self.quantity_per_packg.empty?
  	end
  end

  def self.commodity_type
  	@commodity_type
  end

  def self.commodity_type=(value)
    @commodity_type = value
  end

  def self.of_kit
    Commodity.includes(:commodity_category).where("commodity_categories.com_type = ?", CommodityCategory::TYPES_KIT)
  end  

  def self.of_drug
    Commodity.includes(:commodity_category).where("commodity_categories.com_type = ?", CommodityCategory::TYPES_DRUG)
  end

  def self.from_type type
    Commodity.includes(:commodity_category).where("commodity_categories.com_type = ?", type)
  end  


 

end
