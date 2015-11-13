# == Schema Information
#
# Table name: commodities
#
#  id                    :integer          not null, primary key
#  name                  :string(50)
#  commodity_category_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  unit_id               :integer
#  strength_dosage       :string(255)
#  abbreviation          :string(255)
#  quantity_per_packg    :string(255)
#  pack_size             :float
#  regimen_id            :integer
#  lab_test_id           :integer
#  position              :integer          default(0)
#

class Commodity < ActiveRecord::Base

  attr_accessor :commodity_type

  attr_accessible :commodity_category_id, :commodity_category, :pack_size, :name, :abbreviation, :unit_id,
                  :strength_dosage, :quantity_per_packg, :commodity_type, :lab_test_id, :regimen_id

  belongs_to :commodity_category
  belongs_to :unit

  belongs_to :regimen
  belongs_to :lab_test

  has_many :order_lines

  validates :name, :unit_id, :commodity_category_id, presence: true
  validates :name, uniqueness: true

  validates :strength_dosage, :abbreviation, :quantity_per_packg, :regimen_id, presence: true, if: ->(u) { self.commodity_type == CommodityCategory::TYPES_DRUG }
  validates :pack_size, :lab_test_id, presence: true, if: ->(u) { u.commodity_type == CommodityCategory::TYPES_KIT }
  validates :pack_size, numericality: { greater_than: 0 } , if: ->(u) { u.commodity_type == CommodityCategory::TYPES_KIT }

  # validate :validate_commodity_type
  # def validate_commodity_type
  #   if (self.commodity_type == CommodityCategory::TYPES_DRUG )
  #     errors.add(:abbreviation, "can't be blank") if self.abbreviation.blank?
  #     errors.add(:quantity_per_packg, "can't be blank") if self.quantity_per_packg.blank?
  #     errors.add(:regimen_id, "can't be blank") if self.regimen_id.blank?
  #   else
  #     errors.add(:pack_size, "can't be blank") if self.pack_size.blank?
  #     errors.add(:lab_test_id, "can't be blank") if self.lab_test_id.blank?
  #   end
  # end

  def self.reorder attrs
    attrs.each do |id, position|
      self.where(['id = ?', id]).update_all(position: position)
    end
  end

  def ref_name
    names = []
    if self.commodity_category.kit?
      lab_name = self.try(:lab_test).try(:name)
      names << lab_name if lab_name
    else
      regimen_name = self.try(:regimen).try(:name)
      names << regimen_name if regimen_name
    end
    names << self.name
    names.join(':')
  end

  def to_surv_type
    (self.commodity_category.com_type == CommodityCategory::TYPES_KIT) ? ImportSurv::TYPES_SURV1 : ImportSurv::TYPES_SURV2
  end

  def self.of_kit
    from_type CommodityCategory::TYPES_KIT
  end

  def self.of_drug
    from_type CommodityCategory::TYPES_DRUG
  end

  def self.from_type type
    self.where("commodity_categories.com_type = ?", type)
  end  
end
