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


  default_scope order('order_date DESC, date_submittion DESC')
  attr_accessible :date_submittion, :is_requisition_form, :order_date, :review_date,  :status, :site_id, :order_lines_attributes

  accepts_nested_attributes_for :order_lines

  ORDER_STATUS_PENDING   = 'Pending'
  ORDER_STATUS_COMPLETED = 'Completed'
  ORDER_STATUSES = [ ORDER_STATUS_PENDING, ORDER_STATUS_COMPLETED ]

  def user_site?

  end

  def self.of(user)
    return Order.where("1=1") if user.admin? || user.data_entry?
    return Order.where(['site_id = :site_id', {:site_id => user.site.id}]) if user.site?
    # return Order.where(['user_data_entry_id = :user_id', {:user_id => user.id}]) if user.data_entry?
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
