# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    lat 1.5
    lng 1.5
    service_type "MyString"
    suggestion_order 1.5
    order_frequency 1
    number_of_deadline_sumission 1
    order_start_at "2013-06-05"
    test_kit_waste_acceptable 1.5
    address "MyText"
    contact_name "MyString"
    mobile "MyString"
    land_line_number "MyString"
    email "MyString"
  end
end
