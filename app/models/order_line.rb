class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, :quantity_system_calculation, 
  				  :status, :stock_on_hand, :user_data_entry_note, :user_reviewer_note, :commodity,:arv_type


  class << self
  	def drug
  		where ['arv_type = :type ', :type => CommodityCategory::TYPES_DRUG ]
  	end

  	def kit
  		where [ 'arv_type = :type ', :type => CommodityCategory::TYPES_KIT ]
  	end
  end			  
end
