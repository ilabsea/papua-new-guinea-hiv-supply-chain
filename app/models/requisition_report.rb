# == Schema Information
#
# Table name: requisition_reports
#
#  id           :integer          not null, primary key
#  form         :string(255)
#  site_id      :integer
#  user_id      :integer
#  status       :string(255)      default("PENDING")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_number :string(10)
#

class RequisitionReport < ActiveRecord::Base
   attr_accessible :form, :order_number

   belongs_to :site
   belongs_to :user
   has_one :order, :dependent => :destroy


   IMPORT_STATUS_FAILED  = 'Failed'
   IMPORT_STATUS_SUCCESS = 'Success'
   IMPORT_STATUS_PENDING = 'PENDING'

   IMPORT_STATUSES = [ IMPORT_STATUS_PENDING, IMPORT_STATUS_FAILED, IMPORT_STATUS_SUCCESS ]

   validates :form, :presence => true
   validates :order_number, presence: true
   mount_uploader :form, RequisitionReportUploader

   def save_nested_order
      RequisitionReport.transaction do 
        Order.create_from_requisition_report self
      end
      self.errors.size == 0
   end

end
