class SiteMessageParser
  DELIMITER = '.'	
  ERROR_OK = 0
  ERROR_ERROR = 1

  STATUS_RECEIVED 			= [ 'r','y','yes']
  STATUS_LOST				= [ 'l','n', 'no']
  STATUS_PARTIALLY_RECEIVED = ['p']

  def initialize options
  	@options = options	
  end

  def parse
  	@options[:error] = SiteMessageParser::ERROR_OK
  	@options[:error_type] = :site_message_success
  	validate_content?
  	translate_message
  	@options
  end

  def options
    @options
  end

  def translate_message
    setting = Setting[@options[:error_type]]
    params = {
      :phone_number     => @options[:from_phone],
      :status           => @options[:status],
      :consignment      => @options[:consignment_number],
      :original_message => @options[:message]
    }
    translation = setting.str_tr(params)
    @options[:response_message] = translation
    translation
  end

  def validate_syntax?
    if split_message_components.size != 2
      @options[:error] = SiteMessageParser::ERROR_ERROR
      @options[:error_type] = :site_message_error_syntax
      return false
    end
    true
  end

  def split_message_components
    @message_components ||= @options[:message].strip.split(DELIMITER)
  end

  def validate_content?
    message_components = split_message_components
    consignment_number = message_components[0]
    status      = message_components[1]
    validate_syntax? && validate_consignment_number?(consignment_number) && validate_status?(status)  
  end

  def validate_consignment_number? consignment_number
  	shipment = Shipment.find_by_consignment_number consignment_number
  	if !shipment
  	  @options[:error] = SiteMessageParser::ERROR_ERROR
  	  @options[:error_type] = :site_message_invalid_consignment_number
  	elsif shipment.site.mobile.with_sms_protocol != @options[:from_phone]	
  	  @options[:error] = SiteMessageParser::ERROR_ERROR
  	  @options[:error_type] = :site_message_invalid_sender
    else
      @options[:consignment_number] = consignment_number
      @options[:site] = shipment.site
  	end
  	@options[:error] != SiteMessageParser::ERROR_ERROR
  end
  	
  def validate_status? status
  	status = status.downcase

  	if SiteMessageParser::STATUS_RECEIVED.include? status
  	  @options[:status] = Shipment::STATUS_RECEIVED
  	elsif SiteMessageParser::STATUS_LOST.include? status
  	  @options[:status] = Shipment::STATUS_LOST
  	elsif SiteMessageParser::STATUS_PARTIALLY_RECEIVED.include? status
  	  @options[:status] = Shipment::STATUS_PARTIALLY_RECEIVED 
  	else
  	  @options[:error] = SiteMessageParser::ERROR_ERROR
  	  @options[:error_type] = :site_message_invalid_status
  	end
  	@options[:error] != SiteMessageParser::ERROR_ERROR
  end


end