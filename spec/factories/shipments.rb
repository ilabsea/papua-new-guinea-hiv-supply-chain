FactoryGirl.define do
  factory :shipment do
  	shipment_date '2013-06-25 11:31:27'
  	sequence(:consignment_number){|index| 100000+index} 
  	status Shipment::STATUS_IN_PROGRESS
  	cost 100.25
  	carton 10
  	order
  	user
  	site
  end
end