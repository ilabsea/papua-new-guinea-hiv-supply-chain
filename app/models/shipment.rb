class Shipment < ActiveRecord::Base
	belongs_to :order
	belongs_to :user
	belongs_to :site
	has_one :order_line

	has_many :shipment_lines, :dependent => :destroy
	has_many :sms_logs, :dependent => :destroy

	attr_accessible :shipment_date, :consignment_number

	STATUS_LOST = 'Lost'
	STATUS_RECEIVED = 'Received'
	STATUS_IN_PROGRESS = 'In Progress'

	validates :consignment_number, :shipment_date, :presence => true
	validates :consignment_number, :numericality => true

	SHIPMENT_STATUSES = [STATUS_IN_PROGRESS, STATUS_LOST, STATUS_RECEIVED]

	def self.status_mark
		[ [ STATUS_LOST, "Mark as lost"] , [ STATUS_RECEIVED,  "Mark as received" ] ]  	
	end

	def create_shipment session_shipments
		order_lines = OrderLine.find(session_shipments.map{|session_shipment| session_shipment.order_line_id})
		session_shipments.each do |session_shipment|
		   self.shipment_lines.build(:quantity_issued =>session_shipment.quantity, 
		   		 					 :order_line_id => session_shipment.order_line_id,
		   		 					 :remark => session_shipment.remark,
		   	     					 :quantity_suggested => _quantity_suggested(order_lines, session_shipment.order_line_id )
		   	     					 )
		end
		self.save
	end

	def update_order_lines
		self.shipment_lines.each do |shipment_lines|

		end
	end

	def self.total_shipment_by_status
       shipments = Shipment.select('COUNT(status) AS total, status').group('status').order('total')
       totals= {}
       shipments.each do |shipment|
       	  totals[shipment.status] = shipment.total.to_i
       end
       totals
  	end

	def _quantity_suggested  order_lines , order_line_id
		order_lines.each do |order_line|
		   return order_line._quantity_suggested if order_line.id == order_line_id
		end
		0
	end
end