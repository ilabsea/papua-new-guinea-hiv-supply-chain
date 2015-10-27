# == Schema Information
#
# Table name: sites
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  service_type                 :string(255)
#  suggestion_order             :float
#  order_frequency              :integer
#  number_of_deadline_sumission :integer
#  order_start_at               :date
#  test_kit_waste_acceptable    :float
#  address                      :text
#  contact_name                 :string(255)
#  mobile                       :string(255)
#  land_line_number             :string(255)
#  email                        :string(255)
#  province_id                  :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  in_every                     :integer
#  duration_type                :string(255)
#  sms_alerted                  :integer          default(0)
#  site_messages_count          :integer          default(0)
#  town                         :string(255)
#  region                       :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    sequence(:name){|index| "Site#{index}"}
    service_type "MyString"
    suggestion_order 1.5
    order_frequency 1
    number_of_deadline_sumission 1
    order_start_at "2013-06-05"
    test_kit_waste_acceptable 1.5
    address "MyText"
    contact_name "MyString"
    mobile "MyString"
    land_line_number "MyString"
    email "MyString"
    town "MyString"
    province
    in_every 3
  end
end
