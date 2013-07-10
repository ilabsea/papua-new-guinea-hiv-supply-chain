class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, 
                  :quantity_system_calculation,:status, :stock_on_hand, 
                  :user_data_entry_note, :user_reviewer_note,:arv_type,
                  :commodity_id

  validates :stock_on_hand, :monthly_use, :quantity_system_calculation,
                :numericality => true, :allow_nil => true                

  validate :quantity_suggested!


  def quantity_suggested_drug!
    #CommodityCategory::TYPES_KIT
    site_suggestion = self.order.site.suggestion_order
    calculation = self.calculate_suggested_order
    if calculation > site_suggestion
      errors.add(:quantity_suggested, '(#{calculation}) must be less than or equal to suggestion order of site(#{site_suggestion}) ')
    end
  end

  def quantity_suggested_kit!

    site_suggestion = self.order.site.suggestion_order
    calculation = self.calculate_suggested_order
    if calculation > site_suggestion
      errors.add(:quantity_suggested, '(#{calculation}) must be less than or equal to suggestion order of site(#{site_suggestion}) ')
    end
  end

  def calculate_suggested_order
     value = (self.quantity_system_calculation - self.quantity_suggested).abs
     max = self.quantity_system_calculation > self.quantity_suggested ? self.quantity_system_calculation : self.quantity_suggested
     (100*value)/max
  end              

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
