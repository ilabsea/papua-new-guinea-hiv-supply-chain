# == Schema Information
#
# Table name: sms_logs
#
#  id          :integer          not null, primary key
#  message     :string(255)
#  shipment_id :integer
#  site_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  to          :string(255)
#  sms_type    :string(255)
#  guid        :string(255)
#  status      :string(255)
#

class SmsLog < ActiveRecord::Base
  belongs_to :shipment , :counter_cache => true
  belongs_to :site
  attr_accessible :message, :site, :shipment, :to, :guid, :sms_log, :status, :sms_type

  SMS_TYPE_SHIPMENT = 'Shipment'
  SMS_TYPE_REQUISITION = 'Requisition'
  SMS_TYPE_ASK_CONFIRM  = 'Ask for confirmation'
  
  SMS_TYPES = [SMS_TYPE_SHIPMENT, SMS_TYPE_REQUISITION, SMS_TYPE_ASK_CONFIRM]

  def self.shipment
    of_type SmsLog::SMS_TYPE_SHIPMENT
  end

  def self.requisition
    of_type SmsLog::SMS_TYPE_REQUISITION
  end

  def self.of_type type
    where ['sms_type = :sms_type', :sms_type => type ]
  end
end
