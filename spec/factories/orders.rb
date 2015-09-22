# == Schema Information
#
# Table name: orders
#
#  id                    :integer          not null, primary key
#  site_id               :integer
#  is_requisition_form   :boolean
#  user_place_order_id   :integer
#  order_date            :date
#  user_data_entry_id    :integer
#  review_date           :datetime
#  review_user_id        :integer
#  status                :string(255)
#  requisition_report_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  date_submittion       :date
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    site 
    is_requisition_form false
    date_submittion "2013-06-25 10:58:09"
    user_place_order { create :user_site}
    order_date "2013-06-25 10:58:09"
    user_data_entry { create :user_data_entry}
    review_date "2013-06-25 10:58:09"
    review_user { create :user_reviewer }
    requisition_report nil
    status Order::ORDER_STATUS_PENDING
  end
end
