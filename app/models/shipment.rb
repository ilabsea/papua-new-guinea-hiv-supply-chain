class Shipment < ActiveRecord::Base
	belongs_to :order
	belongs_to :user
	belongs_to :site

	STATUS_LOST = 'Lost'
	STATUS_RECEIVED = 'Received'
	STATUS_PENDING = 'Pending'

	SHIPMENT_STATUSES = [STATUS_PENDING, STATUS_LOST, STATUS_RECEIVED]

	def self.status_mark
		[ [ STATUS_LOST, "Mark as lost"] , [ STATUS_RECEIVED,  "Mark as received" ] ]  	
	end
end