# == Schema Information
#
# Table name: commodity_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  com_type   :string(255)
#

class CommodityCategory < ActiveRecord::Base
  attr_accessible :name, :com_type
  has_many :commodities

  validates :name, :com_type, presence: true
  validates :name, uniqueness: true

  TYPES_DRUG = 'Drug'
  TYPES_KIT  = 'Kit'

  default_scope order("commodity_categories.name ASC")

  TYPES = [TYPES_DRUG, TYPES_KIT ]

  def self.drug
    from_type CommodityCategory::TYPES_DRUG
  end

  def self.kit
    from_type CommodityCategory::TYPES_KIT
  end

  def self.from_type com_type
    where(["com_type = :type ", type: com_type ])
  end

end
