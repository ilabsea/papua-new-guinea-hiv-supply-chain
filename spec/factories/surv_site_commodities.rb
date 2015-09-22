# == Schema Information
#
# Table name: surv_site_commodities
#
#  id           :integer          not null, primary key
#  surv_site_id :integer
#  commodity_id :integer
#  quantity     :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :surv_site_commodity do
    surv_site_id 1
    commodity_id 1
    quantity "MyString"
  end
end
