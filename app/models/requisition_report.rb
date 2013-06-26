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
   
   mount_uploader :form, RequisitionReportUploader

end
