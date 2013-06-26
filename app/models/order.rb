class Order < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user_place_order, :class_name => 'User'
  belongs_to :user_data_entry , :class_name => 'User'
  belongs_to :review_user , :class_name => 'User'
  belongs_to :requisition_report , :class_name => 'RequisitionReport'

  has_many :order_lines

  attr_accessible :date_sumbittion, :is_requisition_form, :order_date, :review_date,  :status

  ORDER_STATUS_PENDING   = 'Pending'
  ORDER_STATUS_COMPLETED = 'Completed'

  ORDER_STATUSES = [ ORDER_STATUS_PENDING, ORDER_STATUS_COMPLETED ]


  def self.create_from_requisition_report requisition_report
  	order = Order.new :date_sumbittion => requisition_report.created_at,
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
  		requisition_report.status = RequisitionReport::IMPORT_STATUS_PENDING	
      requisition_report.save
      return false
  	end
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
