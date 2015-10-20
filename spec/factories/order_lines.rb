# == Schema Information
#
# Table name: order_lines
#
#  id                               :integer          not null, primary key
#  order_id                         :integer
#  commodity_id                     :integer
#  stock_on_hand                    :integer
#  monthly_use                      :integer
#  earliest_expiry                  :datetime
#  quantity_system_calculation      :integer
#  quantity_suggested               :integer
#  user_data_entry_note             :text
#  user_reviewer_note               :text
#  status                           :string(255)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  arv_type                         :string(255)
#  site_suggestion                  :integer
#  test_kit_waste_acceptable        :integer
#  number_of_client                 :integer
#  consumption_per_client_per_month :integer
#  is_set                           :boolean          default(FALSE)
#  shipment_status                  :boolean          default(FALSE)
#  completed_order                  :integer          default(0)
#  order_frequency                  :integer
#  site_id                          :integer
#  pack_size                        :float            default(1.0)
#  system_suggestion                :integer
#  suggestion_order                 :float
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_line do
    order 
    commodity 
    stock_on_hand 1
    monthly_use 1
    system_suggestion 1
    quantity_suggested 1
    quantity_system_calculation 1
    number_of_client 10
    
    site
    order_frequency {site.order_frequency}
    suggestion_order {site.suggestion_order}
    test_kit_waste_acceptable {site.test_kit_waste_acceptable}

    earliest_expiry "2013-06-25 11:31:27"

    user_data_entry_note "Note"
    user_reviewer_note "Note"
  end
end
