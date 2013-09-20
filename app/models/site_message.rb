class SiteMessage < ActiveRecord::Base
  belongs_to :site
  attr_accessible :consignment_number, :from_phone, :guid, :message, :status

  ERROR_OK = 0
  ERROR_ERROR = 1

  DELIMITER = '.'

  def self.parse_message text
  	elements = text.split SiteMessage::DELIMITER
  	options  = {message: text} 
  	if elements.size != 2
  	  options[:error] = SiteMessage::ERROR_ERROR
  	end
  end
end
