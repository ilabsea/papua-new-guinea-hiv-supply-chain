# == Schema Information
#
# Table name: shipments
#
#  id                   :integer          not null, primary key
#  consignment_number   :string(20)
#  status               :string(20)
#  shipment_date        :date
#  received_date        :datetime
#  user_id              :integer
#  site_id              :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sms_logs_count       :integer          default(0)
#  shipment_lines_count :integer          default(0)
#  last_notified_date   :datetime
#  lost_date            :datetime         default(2015-10-08 14:13:02 UTC)
#  cost                 :float
#  carton               :integer
#  site_messages_count  :integer          default(0)
#

FactoryGirl.define do
  factory :shipment do
    shipment_date '2013-06-25 11:31:27'
    status Shipment::STATUS_IN_PROGRESS
    cost 100.25
    carton 10
    order
    user
    site
    sequence(:consignment_number) {|n| (100000000 + n).to_s }
  end
end
