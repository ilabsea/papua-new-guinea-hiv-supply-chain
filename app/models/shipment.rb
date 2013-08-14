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

	def create_shipment shipment_session
		order_lines = OrderLine.find shipment_session.shipment.keys
		shipment_session.shipment.each do |order_line_id, data|
		    options = {  :quantity_issued => data[:quantity], 
						 :order_line_id => order_line_id,
						 :remark => data[:remark],
						 :quantity_suggested => _quantity_suggested(order_lines, order_line_id )
					}	
	
		    shipment_lines.build options
		end
		
		if save
			order_lines.each do |order_line|
				order_line.shipment_status = true
				order_line.save
			end
			return true
		else
			return false	
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
		   return order_line.quantity_suggested if order_line.id == order_line_id
		end
		0
	end
end