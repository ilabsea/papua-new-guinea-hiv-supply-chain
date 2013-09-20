# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site_message do
    message "MyText"
    site nil
    status "MyString"
    consignment_number "MyString"
    guid "MyString"
    from_phone "MyString"
  end
end
