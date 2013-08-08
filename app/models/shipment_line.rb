class ShipmentLine < ActiveRecord::Base
	belongs_to :shipment
	validates :quantity_suggested, :quantity_issued, :presence => true

	attr_accessible :quantity_issued, :quantity_suggested
end