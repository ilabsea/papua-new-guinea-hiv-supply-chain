# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :surv_site do
    import_id 1
    site_id 1
    month "MyString"
    year "MyString"
  end
end
