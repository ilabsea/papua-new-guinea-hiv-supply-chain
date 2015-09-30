# == Schema Information
#
# Table name: lab_test_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lab_test_category do
    sequence(:name) {|n| "lab test category-#{n}"}
  end
end
