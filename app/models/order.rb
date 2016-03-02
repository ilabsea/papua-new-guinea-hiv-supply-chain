# == Schema Information
#
# Table name: orders
#
#  id                    :integer          not null, primary key
#  site_id               :integer
#  is_requisition_form   :boolean
#  user_place_order_id   :integer
#  order_date            :date
#  user_data_entry_id    :integer
#  review_date           :datetime
#  review_user_id        :integer
#  status                :string(15)
#  requisition_report_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  date_submittion       :date
#  order_number          :string(10)
#  rejected_at           :datetime
#  unrejected_at         :datetime
#  approved_at           :datetime
#  approved_user_id      :integer
#

class Order < ActiveRecord::Base
  audited
  belongs_to :site
  belongs_to :user_place_order, :class_name => 'User'
  belongs_to :user_data_entry , :class_name => 'User'
  belongs_to :review_user , :class_name => 'User'
  belongs_to :approved_user, :class_name => 'User'
  belongs_to :requisition_report , :class_name => 'RequisitionReport'

  has_many :order_lines, :dependent => :destroy
  has_many :shipments, dependent: :destroy

  validates :site, :order_date,:date_submittion,:site_id , :presence => true
  validates :user_place_order, :presence => true, :if =>  Proc.new{|f| f.is_requisition_form }
  validates :user_data_entry,  :presence => true, :unless => Proc.new{|f| f.is_requisition_form }
  # validate  :unique_order_in_month_year

  attr_accessor :survs
  attr_accessible :date_submittion, :is_requisition_form, :order_date, :review_date,
                  :status, :site_id, :order_lines_attributes,:surv_sites, :site,
                  :user_place_order, :user_data_entry, :requisition_report, :order_number


  accepts_nested_attributes_for :order_lines

  ORDER_STATUS_PENDING   = 'Pending'
  ORDER_STATUS_TO_BE_REVIEWED = 'To Be Reviewed'
  ORDER_STATUS_APPROVED = 'Approved'
  ORDER_STATUS_TO_BE_REVISED = 'To Be Revised'
  ORDER_STATUS_REJECTED = "Rejected"


  ORDER_STATUSES = [ ORDER_STATUS_PENDING, ORDER_STATUS_TO_BE_REVIEWED, ORDER_STATUS_APPROVED, ORDER_STATUS_TO_BE_REVISED]

  def rejected?
    self.status == Order::ORDER_STATUS_REJECTED
  end

  def approved?
    self.status == Order::ORDER_STATUS_APPROVED
  end

  def pending?
    self.status == Order::ORDER_STATUS_PENDING
  end

  def to_be_reviewed?
    self.status == Order::ORDER_STATUS_TO_BE_REVIEWED
  end

  def to_be_revised?
    self.status == Order::ORDER_STATUS_TO_BE_REVISED
  end

  def update_approval
    self.status = Order::ORDER_STATUS_APPROVED
    self.approved_at = Time.zone.now
    if self.save
      self.order_lines.update_all(status: OrderLine::STATUS_APPROVED)
    end
  end

  def unique_order_in_month_year
    return true if errors.size >0
    order = Order.where(['site_id = :site_id AND MONTH(order_date)= :month AND YEAR(order_date)= :year ',
                   :site_id => self.site.id, :month => self.order_date.month, :year => self.order_date.year
      ]).first

    if(!order.nil? && order.id != self.id)
      date = order.order_date ? order.order_date.strftime(ENV['DATE_FORMAT']) : ''
      errors.add(:site_id, "#{order.site.name} has already had an order on #{date}")
      errors.add(:order_date, "#{order.site.name} has already had an order on #{date}")
    end
  end

  def self.of_status(status)
    where(['status = :status', :status => status])
  end

  def rejectable?
    return false if !approved?
    !shipped?
  end

  def shipped?
    order_lines.where(['shipment_status = ?', true]).first != nil
  end

  def unrejectable?
    return false if !rejected?
    !shipped?
  end

  def self.of_user(user)
    return where("1=1") if user.admin? || user.data_entry? || user.reviewer? || user.data_entry_and_reviewer?
    return where(['site_id = :site_id', {:site_id => user.site.id}]) if user.site?
    return where('status = :status', :status => ORDER_STATUS_APPROVED) if user.ams?
  end

  def self.embed_total_shipped
    shipped = OrderLine.select('order_lines.order_id, count(*) as total_shipped ')
                             .data_filled
                             .where(["order_lines.shipment_status =?", true])
                             .group("order_lines.order_id").to_sql

    orders = self.select("orders.*, shipped.total_shipped").joins("LEFT JOIN (#{shipped}) as shipped ON shipped.order_id = id")
    orders
  end

  def surv_sites
    @survs ||= SurvSite.find_survs(self.site.id, self.order_date)
  end

  def self.create_from_requisition_report requisition_report
    order_line_import = OrderLineImport.new requisition_report.form.current_path

    requisition_report.order_number = order_line_import.order_number.strip
    requisition_report.status = RequisitionReport::IMPORT_STATUS_SUCCESS

    if requisition_report.save
      site =  requisition_report.site
      order = requisition_report.build_order :date_submittion => requisition_report.created_at,
                                            :is_requisition_form => true,
                                            :order_date => Time.zone.now.to_date,
                                            :status  => Order::ORDER_STATUS_PENDING,
                                            :user_place_order => requisition_report.user,
                                            :site => site,
                                            order_number: requisition_report.order_number

      if order.save
        site.order_start_at = Time.zone.now.to_date
        site.sms_alerted = Site::SMS_NOT_ALERTED
        site.save
        order_line_import.import_to(order)
        true
      else
        message = order.errors.full_messages.join("<br />")
        raise ActiveRecord::Rollback, message
      end
    else
      false
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

  def self.total_by_status
    orders = select('COUNT(status) AS total, status').group('status').order('total')
    statuses = {}
     orders.each do |order|
       statuses[order.status] = order.total
     end
     statuses
  end

  def self.in_between date_start, date_end
    orders = where("1=1")
    if !date_start.blank? && !date_end.blank?
      date_start = DateTime.strptime(date_start , ENV['DATE_FORMAT'] )
      date_end   = DateTime.strptime(date_end   , ENV['DATE_FORMAT'] )
      orders = orders.where(['order_date BETWEEN ? AND ?', date_start.beginning_of_day, date_end.end_of_day ])
    end
    orders
  end

  def self.approved
    where("orders.status = :status", :status => Order::ORDER_STATUS_APPROVED)
  end

  def update_status_accepted
    accepted = true
    self.order_lines.each do |order_line|
      if order_line.status != OrderLine::STATUS_APPROVED
        accepted = false
        break
      end
    end

    if accepted
      self.status = Order::ORDER_STATUS_APPROVED
    end
  end
end
