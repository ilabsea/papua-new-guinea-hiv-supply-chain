# == Schema Information
#
# Table name: regimen_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regimen_category do
    sequence(:name) {|n| "regimen-category-#{n}"}
    description "MyText"
  end
end
