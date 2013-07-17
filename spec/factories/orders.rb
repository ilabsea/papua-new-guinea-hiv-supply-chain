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
    review_user { create :user_reviewer}
    requisition_report nil
    status Order::ORDER_STATUS_PENDING
  end
end
