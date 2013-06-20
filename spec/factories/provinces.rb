# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :province do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:code) { |n| "Code #{n}" }
  end
end
