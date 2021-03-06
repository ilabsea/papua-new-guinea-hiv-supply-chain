# == Schema Information
#
# Table name: commodity_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  com_type   :string(255)
#  pos        :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :commodity_category do
    sequence(:name) {|n| "Category_#{n}"}
    com_type 'Kit'
  end
end
