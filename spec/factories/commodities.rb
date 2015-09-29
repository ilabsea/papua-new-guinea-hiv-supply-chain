# == Schema Information
#
# Table name: commodities
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  commodity_category_id       :integer
#  consumption_per_client_pack :integer
#  consumption_per_client_unit :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  unit_id                     :integer
#  strength_dosage             :string(255)
#  abbreviation                :string(255)
#  quantity_per_packg          :string(255)
#  pack_size                   :float
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity do
    sequence(:name){|index| "Site#{index}"}
    commodity_category
    consumption_per_client_pack 1
    consumption_per_client_unit 1
    commodity_type { CommodityCategory::TYPES_KIT} 
    unit
    pack_size 3.0
  end
end
