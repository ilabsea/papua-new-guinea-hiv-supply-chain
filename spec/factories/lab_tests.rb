# == Schema Information
#
# Table name: lab_tests
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  lab_test_category_id :integer
#  unit_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lab_test do
    sequence(:name) {|n| "lab test #{n}" }
    lab_test_category
    unit
  end
end
