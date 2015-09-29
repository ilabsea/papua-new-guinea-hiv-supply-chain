# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regiman, :class => 'Regimen' do
    name "MyString"
    regimen_category nil
    unit nil
    strength_dosage "MyString"
  end
end
