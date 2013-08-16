class SmsLog < ActiveRecord::Base
	belongs_to :shipment , :counter_cache => true
	belongs_to :site
	attr_accessible :message, :site, :shipment, :to
end