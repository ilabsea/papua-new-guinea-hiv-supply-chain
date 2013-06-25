# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_line do
    order nil
    commodity nil
    stock_on_hand 1
    monthly_use 1
    earliest_expiry "2013-06-25 11:31:27"
    quantity_system_calculation 1
    quantity_suggested 1
    user_data_entry_note "MyText"
    user_reviewer_note "MyText"
    status "MyString"
  end
end
