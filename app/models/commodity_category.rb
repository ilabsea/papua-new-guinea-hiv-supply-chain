# == Schema Information
#
# Table name: commodity_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  com_type   :string(255)
#  pos        :integer          default(0)
#

class CommodityCategory < ActiveRecord::Base
  attr_accessible :name, :com_type
  has_many :commodities

  validates :name, :com_type, presence: true
  validates :name, uniqueness: true

  TYPES_DRUG = 'Drug'
  TYPES_KIT  = 'Kit'

  TYPES = [TYPES_DRUG, TYPES_KIT ]

  def self.reorder attrs
    p "------------"
    p attrs
    attrs.each do |id, position|
      self.where(['id = ?', id]).update_all(pos: position)
    end
  end

  def kit?
    self.com_type == CommodityCategory::TYPES_KIT
  end

  def drug?
    self.com_type == CommodityCategory::TYPES_DRUG
  end

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
