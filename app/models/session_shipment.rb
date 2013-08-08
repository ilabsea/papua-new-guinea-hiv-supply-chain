class SessionShipment
	
   include ActiveModel::Validations
   include ActiveModel::Conversion
   extend  ActiveModel::Naming

	attr_accessor :quantity, :remark, :order_line_id

	validates :quantity, :order_line_id, :numericality => true

	def initialize(attributes={})
	   attributes && attributes.each do |name, value|
	     send("#{name}=", value) if respond_to? name.to_sym 
	   end
	end

	def order_line
	   @order_line ||= OrderLine.includes(:order => :site).find self.order_line_id
	end
	
	def self.persisted?
		false
	end

end