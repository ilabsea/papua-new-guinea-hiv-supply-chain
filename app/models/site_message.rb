# == Schema Information
#
# Table name: site_messages
#
#  id                 :integer          not null, primary key
#  message            :text
#  site_id            :integer
#  status             :string(255)
#  consignment_number :string(255)
#  guid               :string(255)
#  from_phone         :string(255)
#  error              :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  response_message   :string(255)
#  carton             :integer
#  shipment_id        :integer
#

class SiteMessage < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  belongs_to :shipment, :counter_cache => true
  attr_accessible :consignment_number, :from_phone, :guid, :message, :status, :site, :response_message, :error, :carton, :shipment
  default_scope order('id DESC')

  def to_nuntium
    {:to => self.from_phone.with_sms_protocol, :body => self.response_message}
  end

  def display_error
    self.error == SiteMessageParser::ERROR_ERROR ? 'Yes' : 'No'
  end
end
