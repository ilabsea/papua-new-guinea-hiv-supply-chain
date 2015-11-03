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
#  position              :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity do
    sequence(:name){|index| "Site#{index}"}
    commodity_category
    commodity_type { CommodityCategory::TYPES_KIT}
    lab_test
    regimen
    unit
    pack_size 3.0
    strength_dosage '300mg'
  end
end
