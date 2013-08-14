class ShipmentLineSession
	
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

	attr_accessor :quantity, :remark, :order_line_id, :shipment_session

	validates :quantity, :presence => true
	validates :quantity, :order_line_id, :numericality => true
	validate  :in_same_order

	def initialize(attributes={})
	   attributes && attributes.each do |name, value|
	     send("#{name}=", value) if respond_to? name.to_sym 
	   end
	end

	def in_same_order

	  begin 	
		line1 = OrderLine.find self.order_line_id	
		if @shipment_session.shipment.first
		  order_line_id = @shipment_session.shipment.first[0]
		  line2 = OrderLine.find order_line_id
		  errors.add(:order_line_id, "can not be added to shipment of different order") if line1.order_id != line2.order_id
		end
	  rescue Exception => ex
	  	errors.add(:order_line_id, "invalid commodity order. Please try again")
	  end


	end

	def set_container shipment_session
		@shipment_session = shipment_session
	end

	def order_line
	   @order_line ||= OrderLine.includes(:order => :site).find self.order_line_id
	end

	def data
	  { :quantity => self.quantity.to_i, :order_line_id => self.order_line_id.to_i , :remark => self.remark }
	end
	
	def self.persisted?
		false
	end

end