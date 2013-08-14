class ShipmentSession
	attr_accessor :session

	def initialize session
		@session = session
	end

	def shipment
		@session[:shipment] ||= Hash.new
	end

	def size
		self.shipment.size
	end

	def empty?
		self.size == 0
	end

	def clear
		@session[:shipment] = {}
	end

	def find_by_key order_line_id
		self.shipment[order_line_id.to_i]
	end

	def add shipment_line
		@session[:shipment] ||= Hash.new
		@session[:shipment][shipment_line.order_line_id.to_i] = shipment_line.data
		return shipment_line.data
	end

	def delete order_line_id
		if @session[:shipment]
		   element = self.find_by_key order_line_id.to_i
		   @session[:shipment].delete order_line_id.to_i
		   return element
		end
		nil
	end
end