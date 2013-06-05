# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity do
    name "MyString"
    commodity_category_id 1
    consumption_per_client_pack 1
    consumption_per_client_unit 1
  end
end
