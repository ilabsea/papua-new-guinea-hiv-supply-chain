class ShipmentLine < ActiveRecord::Base
	belongs_to :shipment, :counter_cache => true
	belongs_to :order_line

	validates :quantity_issued, :presence => true, :allow_blank => true
	attr_accessible :quantity_issued, :quantity_suggested, :order_line_id, :remark
end