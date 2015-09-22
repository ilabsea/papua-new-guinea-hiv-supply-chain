# encoding: utf-8
# == Schema Information
#
# Table name: order_lines
#
#  id                               :integer          not null, primary key
#  order_id                         :integer
#  commodity_id                     :integer
#  stock_on_hand                    :integer
#  monthly_use                      :integer
#  earliest_expiry                  :datetime
#  quantity_system_calculation      :integer
#  quantity_suggested               :integer
#  user_data_entry_note             :text
#  user_reviewer_note               :text
#  status                           :string(255)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  arv_type                         :string(255)
#  site_suggestion                  :integer
#  test_kit_waste_acceptable        :integer
#  number_of_client                 :integer
#  consumption_per_client_per_month :integer
#  is_set                           :boolean          default(FALSE)
#  shipment_status                  :boolean          default(FALSE)
#  completed_order                  :integer          default(0)
#  order_frequency                  :float
#  site_id                          :integer
#

class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :commodity
  belongs_to :site
  has_one :shipment_line, :dependent => :destroy

  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, :status, :order, :stock_on_hand, :number_of_client,
                  :user_data_entry_note, :user_reviewer_note,:arv_type, :commodity_id, :site_id, :site, :is_set, :skip_bulk_insert,:commodity

  validates :stock_on_hand , :numericality => {:greater_than_or_equal_to => 0}, :if => Proc.new{|ol| ol.number_of_client && ol.quantity_suggested }
  validates :quantity_suggested , :numericality => {:greater_than => 0}, :if => Proc.new{|ol| ol.number_of_client && ol.stock_on_hand }

  validates :monthly_use, :numericality => {:greater_than_or_equal_to => 0}, :if =>  Proc.new{|ol| ol.arv_type == CommodityCategory::TYPES_KIT &&  ol.number_of_client && ol.stock_on_hand }

  default_scope order('monthly_use DESC')
  validate :validate_requirement
  before_save :calculate_attribute

  attr_accessor :skip_bulk_insert

  STATUS_APPROVED = 'Approved'
  STATUS_REJECTED = 'Rejected'

  DATA_COMPLETE   = 1
  DATA_INCOMPLETE = 0

  attr_accessor :temp_order


  STATUSES = [STATUS_APPROVED, STATUS_REJECTED]

  def message_error_line
    "<ul>" +  errors.full_messages.map{|error| "<li>#{error}</li>"}.join("") + "</ul>"
  end

  def skip_bulk_insert=(val)
    @skip_bulk_insert = val
  end

  def skip_bulk_insert
    @skip_bulk_insert
  end

  def calculate_attribute
    calculate_completed_order
  end

  def calculate_completed_order
    complete_order_line = number_of_client && stock_on_hand && quantity_suggested
    if self.arv_type == CommodityCategory::TYPES_KIT
      complete_order_line = (complete_order_line && monthly_use) 
    end

    self.completed_order = complete_order_line ? OrderLine::DATA_COMPLETE : OrderLine::DATA_INCOMPLETE
  end

  def calculate_system_suggestion
      @quantity_system_calculation ||= cal_system_suggestion
  end

  def validate_requirement
    return true if skip_bulk_insert
    return true if errors.size >0
    return true if number_of_client.nil? 
    return true if self.site.nil?

    if arv_type == CommodityCategory::TYPES_DRUG 
      return true if stock_on_hand.nil? && quantity_suggested.nil?
      validate_quantity_suggested_value 
    else
      return true if stock_on_hand.nil? && quantity_suggested.nil?
      validate_quantity_suggested_value
      return true if monthly_use.nil?
      validate_quantity_wastage_value
    end
  end

  def filter number
     number.to_s + "%"
  end

  def cal_drug
    system_suggestion = cal_system_suggestion

    diff = self.quantity_suggested - system_suggestion 
    max  = self.quantity_suggested >= system_suggestion ?  self.quantity_suggested : system_suggestion
    100 * diff.abs / max
  end

  def cal_kit
    system_suggestion = cal_system_suggestion
    100 * (self.monthly_use - system_suggestion) / system_suggestion
  end

  def cal_system_suggestion
    return '' if (!self.order && !self.site) || !self.stock_on_hand

    consumtion = self.number_of_client.to_i * self.commodity.consumption_per_client_unit * self.site.order_frequency.to_f
    system_suggestion = consumtion - self.stock_on_hand.to_f
  end

  def validate_quantity_suggested_value
    cal = cal_drug
    if cal > self.site.suggestion_order.to_f
        message = "<b>" + self.commodity.name + "</b>: Quantity Suggested is not within " + filter(self.site.suggestion_order) + " of population consumption"
        errors.add(:quantity_suggested, message)
        return false     
    end
    return true
  end

  def validate_quantity_wastage_value 
    cal = cal_kit
    if(cal > self.site.test_kit_waste_acceptable.to_f)
      message = "<b>" + self.commodity.name + "</b>: Monthly use declared by site is greater than " + filter(self.site.test_kit_waste_acceptable)  + " of acceptable wastage" 
      errors.add(:monthly_use, message) 
      return false
    end
    return true
  end

  def calculate_suggested_order
     value = (self.calculate_system_suggestion - self.quantity_suggested).abs
     max = self.calculate_system_suggestion > self.quantity_suggested ? self.calculate_system_suggestion : self.quantity_suggested
     (100*value)/max
  end 

  def self.items site_id
    order_lines = OrderLine.includes(:commodity, :order => :site ).joins(:order).where([ "orders.status = :order_status AND order_lines.shipment_status = 0", :order_status => Order::ORDER_STATUS_APPROVED])
    if !site_id.blank?
      order_lines = order_lines.where("orders.site_id = :site_id", :site_id => site_id )
    end
    order_lines
  end             

  def calculate_quantity_system_suggestion temp_order
    # return false if self.is_se
    self.site = temp_order.site
    surv_sites = temp_order.surv_sites
    surv_sites.each do |type, surv_site| 
      if surv_site
        surv_site.surv_site_commodities.each do |surv_site_commodity|
          if surv_site_commodity.commodity == self.commodity
            self.number_of_client            = surv_site_commodity.quantity.to_i      
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

    def not_shipped
      where [ 'shipment_status = :shipment_status', :shipment_status => false]
    end

    def data_filled
      where ['completed_order = :completed', :completed => OrderLine::DATA_COMPLETE]
    end
  end	

end
