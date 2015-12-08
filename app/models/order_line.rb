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
#  order_frequency                  :integer
#  site_id                          :integer
#  pack_size                        :float            default(1.0)
#  system_suggestion                :integer
#  suggestion_order                 :float
#

class OrderLine < ActiveRecord::Base
  audited
  belongs_to :order
  belongs_to :commodity
  belongs_to :site
  has_one :shipment_line, :dependent => :destroy

  attr_accessible :earliest_expiry, :monthly_use, :quantity_suggested, :status, :order, :stock_on_hand,
                  :number_of_client, :user_data_entry_note, :user_reviewer_note,:arv_type, :commodity_id, :system_suggestion,
                  :site_id, :site, :test_kit_waste_acceptable, :suggestion_order, :order_frequency,
                  :is_set, :skip_bulk_insert,:commodity, :pack_size

  validates :quantity_suggested, numericality: {greater_than_or_equal_to: 0, allow_blank: true}

  validates :stock_on_hand, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  validates :monthly_use, numericality: {greater_than_or_equal_to: 0, allow_blank: true}
  # validates :number_of_client, numericality: {greater_than_or_equal_to: 0 }

  # validate :validate_requirement
  before_save :calculate_attribute

  attr_accessor :skip_bulk_insert

  STATUS_APPROVED = 'Approved'
  STATUS_REJECTED = 'Rejected'

  DATA_COMPLETE   = 1
  DATA_INCOMPLETE = 0


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
    complete_order_line = (monthly_use || stock_on_hand) && quantity_suggested

    # complete_order_line = number_of_client && stock_on_hand && quantity_suggested
    # if self.arv_type == CommodityCategory::TYPES_KIT
    #   complete_order_line = (complete_order_line && monthly_use)
    # end
    self.completed_order = complete_order_line ? OrderLine::DATA_COMPLETE : OrderLine::DATA_INCOMPLETE
  end


  def validate_requirement
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
    diff = self.quantity_suggested - self.system_suggestion
    max  = self.quantity_suggested >= self.system_suggestion ?  self.quantity_suggested : self.system_suggestion
    100 * diff.abs / max
  end

  def cal_kit
    100 * (self.monthly_use - self.system_suggestion) / self.system_suggestion
  end

  def validate_quantity_suggested_value
    if cal_drug > self.suggestion_order.to_f
        message = "<b>" + self.commodity.name + "</b>: Quantity Suggested is not within " + filter(self.suggestion_order) + " of population consumption"
        errors.add(:quantity_suggested, message)
        return false
    end
    return true
  end

  def validate_quantity_wastage_value 
    if(cal_kit > self.test_kit_waste_acceptable.to_f)
      message = "<b>" + self.commodity.name + "</b>: Monthly use declared by site is greater than " + filter(self.test_kit_waste_acceptable)  + " of acceptable wastage" 
      errors.add(:monthly_use, message) 
      return false
    end
    return true
  end

  def calculate_suggested_order
     value = (self.system_suggestion - self.quantity_suggested).abs
     max = self.system_suggestion > self.quantity_suggested ? self.system_suggestion : self.quantity_suggested
     (100*value)/max
  end 

  def self.items options
    order_lines = self.joins("INNER JOIN orders ON order_lines.order_id = orders.id")
                      .where([ "order_lines.shipment_status = 0 AND orders.status = ?", Order::ORDER_STATUS_APPROVED])
    

    # teach database to use indices in order table with index(:status, :site_id) 
    order_lines = options[:site_id].blank? ? order_lines.where( "orders.site_id > -1" ) : order_lines.where(["orders.site_id = ?", options[:site_id]] )

    order_lines = order_lines.where(["orders.date_submittion <= ?", Date.strptime(options[:end], ENV['DATE_FORMAT']) ]) if !options[:end].blank?
    order_lines = order_lines.where(["orders.date_submittion >= ?", Date.strptime(options[:start], ENV['DATE_FORMAT']) ]) if !options[:start].blank?
    order_lines
  end

  def drug?
   self.arv_type == CommodityCategory::TYPES_DRUG
  end

  def kit?
    self.arv_type == CommodityCategory::TYPES_KIT
  end

  def monthly_use_pack
    self.drug? ? monthly_use : (monthly_use/pack_size).ceil
  end

  def stock_on_hand_pack
    self.drug? ? stock_on_hand : (stock_on_hand/pack_size).ceil
  end

  class << self
    def drug
      where ['arv_type = :type ', :type => CommodityCategory::TYPES_DRUG ]
    end

    def kit
      where [ 'arv_type = :type ', :type => CommodityCategory::TYPES_KIT ]
    end

    def not_shipped
      where [ 'order_lines.shipment_status = :shipment_status', :shipment_status => false]
    end

    def data_filled
      where ['completed_order = :completed', :completed => OrderLine::DATA_COMPLETE]
    end
  end  

end
