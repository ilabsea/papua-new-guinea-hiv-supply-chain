# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    site nil
    is_requisition_form false
    date_sumbittion "2013-06-25 10:58:09"
    user_place_order nil
    order_date "2013-06-25 10:58:09"
    user_data_entry nil
    review_date "2013-06-25 10:58:09"
    review_user ""
    status "MyString"
    requisition_report nil
  end
end
