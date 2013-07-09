class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, 
                  :quantity_system_calculation,:status, :stock_on_hand, 
                  :user_data_entry_note, :user_reviewer_note,:arv_type,
                  :commodity_id

  validates :stock_on_hand, :quantity_suggested, :monthly_use, :quantity_system_calculation,
                :numericality => true, :allow_nil => true                


  attr_accessor :system_suggestion, :quantity_suggested


  class << self
  	def drug
  		where ['arv_type = :type ', :type => CommodityCategory::TYPES_DRUG ]
  	end

  	def kit
  		where [ 'arv_type = :type ', :type => CommodityCategory::TYPES_KIT ]
  	end
  end			  
end
