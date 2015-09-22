# == Schema Information
#
# Table name: requisition_reports
#
#  id         :integer          not null, primary key
#  form       :string(255)
#  site_id    :integer
#  user_id    :integer
#  status     :string(255)      default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RequisitionReport < ActiveRecord::Base
   attr_accessible :form
   #site_id, user_id

   belongs_to :site
   belongs_to :user
   has_one :order

   IMPORT_STATUS_FAILED  = 'Failed'
   IMPORT_STATUS_SUCCESS = 'Success'
   IMPORT_STATUS_PENDING = 'PENDING'

   IMPORT_STATUSES = [ IMPORT_STATUS_PENDING, IMPORT_STATUS_FAILED, IMPORT_STATUS_SUCCESS ]

   validates :form, :presence => true 
   mount_uploader :form, RequisitionReportUploader

   def save_nested_order
      RequisitionReport.transaction do 
         if(save)
            order = Order.create_from_requisition_report self
            return true if order.errors.size == 0

            message = order.errors.full_messages.join("<br />") 
            errors.add(:form, message)
            raise ActiveRecord::Rollback, message
         end         
      end
      errors.size == 0
   end

end
