# == Schema Information
#
# Table name: regimen
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  regimen_category_id :integer
#  unit_id             :integer
#  strength_dosage     :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regimen, :class => 'Regimen' do
    sequence(:name) {|n| "regimen-#{n}"}
    regimen_category
    unit
    strength_dosage ""
  end
end
