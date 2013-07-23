class Order < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user_place_order, :class_name => 'User'
  belongs_to :user_data_entry , :class_name => 'User'
  belongs_to :review_user , :class_name => 'User'
  belongs_to :requisition_report , :class_name => 'RequisitionReport'

  has_many :order_lines, :dependent => :destroy

  validates :site, :order_date,:date_submittion, :presence => true
  validates :user_place_order, :presence => true, :if =>  Proc.new{|f| f.is_requisition_form }
  validates :user_data_entry,  :presence => true, :unless => Proc.new{|f| f.is_requisition_form }
  validate  :unique_order_in_month_year


  default_scope order('order_date DESC, id DESC')

  attr_accessor :survs
  attr_accessible :date_submittion, :is_requisition_form, :order_date, :review_date,  
                  :status, :site_id, :order_lines_attributes,:surv_sites, :site, 
                  :user_place_order, :user_data_entry, :requisition_report


  accepts_nested_attributes_for :order_lines

  ORDER_STATUS_PENDING   = 'Pending'
  ORDER_STATUS_COMPLETED = 'Completed'
  ORDER_STATUSES = [ ORDER_STATUS_PENDING, ORDER_STATUS_COMPLETED ]

  before_save :order_lines_calculation

  def unique_order_in_month_year
    order = Order.where(['site_id = :site_id AND MONTH(order_date)= :month AND YEAR(order_date)= :year ',
                   :site_id => self.site.id, :month => self.order_date.month, :year => self.order_date.year
      ]).first

    if(!order.nil? && order.id != self.id)
      errors.add(:site_id, "#{order.site.name} has already had an order on #{order.order_date}")
      errors.add(:order_date, "#{order.site.name} has already had an order on #{order.order_date}")
    end
  end

  def self.of(user)
    return Order.where("1=1") if user.admin? || user.data_entry?
    return Order.where(['site_id = :site_id', {:site_id => user.site.id}]) if user.site?
    # return Order.where(['user_data_entry_id = :user_id', {:user_id => user.id}]) if user.data_entry?
  end

  def surv_sites
    @survs ||= SurvSite.find_survs(self.site.id, self.order_date)
  end


  def order_lines_calculation
    #foreach order_line update field data by current order
    self.order_lines.each do |order_line|
      order_line.calculate_quantity_system_suggestion(self)
    end
  end

  def self.in_between date_start, date_end
     if(!date_start.blank? && !date_end.blank?)
       where(['order_date BETWEEN :date_start AND :date_end', :date_start => date_start, :date_end => date_end])
     elsif !date_start.blank?
       where(['order_date >= :date_start', :date_start => date_start])
     elsif !date_end.blank?
       where(['order_date <= :date_end', :date_end => date_end])
     else
       where "1=1"      
     end
  end

  def self.create_from_requisition_report requisition_report
  	order = Order.new :date_submittion => requisition_report.created_at,
											 :is_requisition_form => true,
											 :order_date => Time.now(), 
											 :status  => Order::ORDER_STATUS_PENDING

  	order.user_place_order   = requisition_report.user
  	order.site 				 = requisition_report.site
  	order.requisition_report = requisition_report

  	if order.save
  		requisition_report.status = RequisitionReport::IMPORT_STATUS_SUCCESS
      requisition_report.save
      OrderLineImport.import order
      return true
  	else
  		requisition_report.status = RequisitionReport::IMPORT_STATUS_FAILED	
      requisition_report.save
      return false
  	end
  end

  def users_from_site
     site = self.site || Site.new
     site.users
  end

  def import_order_lines
  	file_name = order.requisition_report.current_path

  end

  def user_type
  	 return user_place_order.nil? ? 'Data Entry' : 'Site'
  end

  def user
  	self.user_place_order || self.user_data_entry
  end

end
