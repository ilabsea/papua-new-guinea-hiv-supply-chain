# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unit do
    sequence(:name){|index| "Unit#{index}"}  
  end
end
