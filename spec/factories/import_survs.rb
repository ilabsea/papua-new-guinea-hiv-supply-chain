# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :import_surv do
    surv_type 1
    name "MyString"
    import_user 1
  end
end
