class SiteMessage < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :consignment_number, :from_phone, :guid, :message, :status, :site, :response_message, :error, :carton

  def to_nuntium
    {:to => self.from_phone.with_sms_protocol, :body => self.response_message, :from => Sms::APP_NAME}
  end

  def display_error
  	self.error == SiteMessageParser::ERROR_ERROR ? 'Yes' : 'No'
  end
end
