class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, :quantity_system_calculation, :status, :order,
                  :stock_on_hand, :user_data_entry_note, :user_reviewer_note,:arv_type, :commodity_id, :is_set, :skip_bulk_insert,
                  :site_suggestion, :test_kit_waste_acceptable, :number_of_client, :consumption_per_client_per_month,:commodity

  validates :stock_on_hand, :monthly_use, :quantity_system_calculation, :numericality => true, :allow_nil => true   
  validates :quantity_suggested, :numericality => true ,:allow_blank => true         

  default_scope order('monthly_use DESC')
  validate :quantity_suggested_valid?
  before_save :calculate_attribute

  attr_accessor :skip_bulk_insert

  STATUS_APPROVED = 'Approved'
  STATUS_REJECTED = 'Rejected'

  STATUSES = [STATUS_APPROVED, STATUS_REJECTED]

  def skip_bulk_insert=(val)
    @skip_bulk_insert = val
  end

  def skip_bulk_insert
    @skip_bulk_insert
  end

  def calculate_attribute
      calculate_system_suggestion
  end

  def calculate_system_suggestion
    total                            =  self.consumption_per_client_per_month.to_i * self.number_of_client.to_i
    self.quantity_system_calculation = total - self.stock_on_hand.to_i
  end

  def quantity_suggested_valid?
    return true if skip_bulk_insert
    arv_type == CommodityCategory::TYPES_DRUG ? quantity_suggested_drug? : quantity_suggested_kit?
  end

  def filter number
     number.to_s + "%"
  end

  def cal_drug
    consumtion        = self.number_of_client.to_i * self.consumption_per_client_per_month.to_i
    system_suggestion = consumtion - self.stock_on_hand.to_i
    diff = self.quantity_suggested - system_suggestion 
    max  = self.quantity_suggested >= system_suggestion ?  self.quantity_suggested : system_suggestion
    100 * diff.abs / max
  end

  def cal_kit
    consumtion = self.number_of_client.to_i * self.consumption_per_client_per_month.to_i
    system_suggestion = consumtion - self.stock_on_hand.to_i
    100 * (self.monthly_use - system_suggestion) / system_suggestion
  end

  def quantity_suggested_drug?
    return true  if ( stock_on_hand.blank?  || quantity_suggested.blank?)
    cal = cal_drug
    if cal > self.site_suggestion.to_f
        message = "<b>" + self.commodity.name + "</b>: Quantity Suggested is not within " + filter(self.site_suggestion) + " of population consumption"
        errors.add(:quantity_suggested, message)
        errors.add(:stock_on_hand, message)      
        return false     
    end
    return true
  end

  def quantity_suggested_kit?
    return true if(self.stock_on_hand.blank?  || self.monthly_use.blank? || self.number_of_client.to_i ==0 || self.consumption_per_client_per_month.to_i ==0 )     
    cal = cal_kit
    if(cal > self.test_kit_waste_acceptable.to_f)
      message = "<b>" + self.commodity.name + "</b>: Monthly use declared by site is greater than " + filter(self.test_kit_waste_acceptable)  + " of acceptable wastage" 
      errors.add(:monthly_use, message) 
      errors.add(:stock_on_hand, message) 
      return false
    end
    return true
  end

  def calculate_suggested_order
     value = (self.quantity_system_calculation - self.quantity_suggested).abs
     max = self.quantity_system_calculation > self.quantity_suggested ? self.quantity_system_calculation : self.quantity_suggested
     (100*value)/max
  end              

  def calculate_quantity_system_suggestion temp_order
    return false if self.is_set
    surv_sites = temp_order.surv_sites
    surv_sites.each do |type, surv_site| 
      if surv_site
        surv_site.surv_site_commodities.each do |surv_site_commodity|
          if surv_site_commodity.commodity == self.commodity
            self.site_suggestion             = temp_order.site.suggestion_order
            self.test_kit_waste_acceptable   = temp_order.site.test_kit_waste_acceptable
            self.number_of_client            = surv_site_commodity.quantity.to_i
            self.is_set = true 
            break
          end
        end
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
