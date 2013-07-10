class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, 
                  :quantity_system_calculation,:status, :stock_on_hand, 
                  :user_data_entry_note, :user_reviewer_note,:arv_type,
                  :commodity_id

  validates :stock_on_hand, :quantity_suggested, :monthly_use, :quantity_system_calculation,
                :numericality => true, :allow_nil => true                



  def calculate_quantity_system_calculation surv_site
    surv_site.surv_site_commodities.each do |surv_site_commodity|
      if surv_site_commodity.commodity == self.commodity
          total = surv_site_commodity.quantity.to_i * commodity.consumption_per_client_unit.to_i
          system_suggestion = total - self.stock_on_hand.to_i
          self.quantity_system_calculation = system_suggestion
          break
      end
    end
  end

  class << self
  	def drug
  		where ['arv_type = :type ', :type => CommodityCategory::TYPES_DRUG ]
  	end

  	def kit
  		where [ 'arv_type = :type ', :type => CommodityCategory::TYPES_KIT ]
  	end
  end			  
end
