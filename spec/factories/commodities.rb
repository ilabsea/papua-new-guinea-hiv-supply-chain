# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity do
    sequence(:name){|index| "Site#{index}"}
    commodity_category
    consumption_per_client_pack 1
    consumption_per_client_unit 1
    commodity_type { CommodityCategory::TYPES_KIT} 
    unit
  end
end
