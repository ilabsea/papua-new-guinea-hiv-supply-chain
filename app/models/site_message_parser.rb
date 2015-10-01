class SiteMessageParser
  DELIMITER = ' '
  ERROR_OK = 0
  ERROR_ERROR = 1

  STATUS_RECEIVED = [ 'r','y','yes', 'received']
  STATUS_LOST = [ 'l','n', 'no', 'not', 'lost']
  STATUS_PARTIALLY_RECEIVED = ['p', 'partial']

  def initialize params
    @options = params  
  end

  def parse
    @options[:error] = SiteMessageParser::ERROR_OK
    @options[:error_type] = :site_message_success
    validate_content?
    translate_message
    @options
  end

  def process
    parse
    attrs = self.options.slice(:consignment_number, :status, :site, :guid, :response_message, :error, :carton, :shipment)

    attrs[:message] = self.options[:body]
    attrs[:from_phone] = self.options[:from].without_sms_protocol
    attrs[:site] = self.options[:site]

    site_message = SiteMessage.new(attrs)
    site_message.save(:validate => false)

    if site_message.error == SiteMessageParser::ERROR_OK
      @options[:shipment].update_status(site_message.status)
    end
    site_message 
  end

  def options
    @options
  end

  def translate_message
    setting = Setting[@options[:error_type]]
    params = {
      :phone_number => @options[:from].without_sms_protocol,
      :status => @options[:status],
      :consignment => @options[:consignment_number],
      :original_message => @options[:body],
      :carton_number => @options[:carton]
    }
    translation = setting.str_tr(params)
    @options[:response_message] = translation
    translation
  end

  def validate_syntax?
    message_components = split_message_components
    if message_components.size < 2 #&& message_components.size != 3
      @options[:error] = SiteMessageParser::ERROR_ERROR
      @options[:error_type] = :site_message_error_syntax
      return false
    end
    true
  end

  def split_message_components
    @message_components ||= @options[:body].strip.split(DELIMITER)
  end

  def validate_content?
    message_components = split_message_components
    consignment_number = message_components[0]
    status             = message_components[1]
    carton_number      = message_components[2]
    validate_syntax? && validate_consignment_number?(consignment_number) && validate_status?(status) && validate_carton?(carton_number)
  end


  def validate_consignment_number? consignment_number
    shipment = Shipment.find_by_consignment_number consignment_number
    if !shipment
      @options[:error] = SiteMessageParser::ERROR_ERROR
      @options[:error_type] = :site_message_invalid_consignment_number
    else  
      if shipment.site.mobile.with_sms_protocol != @options[:from]  
        @options[:error] = SiteMessageParser::ERROR_ERROR
        @options[:error_type] = :site_message_invalid_sender
      else
        @options[:consignment_number] = consignment_number
        @options[:site] = shipment.site
        @options[:shipment] = shipment
      end  
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

  def validate_carton? carton_number
    # if @options[:status] == Shipment::STATUS_PARTIALLY_RECEIVED 
    #   if carton_number.blank? || !carton_number.is_numeric? 
    #     @options[:error] = SiteMessageParser::ERROR_ERROR
    #     @options[:error_type] = :site_message_invalid_carton_format  
    #     return false
    #   end
    # elsif @options[:status] != Shipment::STATUS_PARTIALLY_RECEIVED && !carton_number.blank?
    #   @options[:error] = SiteMessageParser::ERROR_ERROR
    #   @options[:error_type] = :site_message_invalid_carton_format
    #   return false
    # end
    @options[:carton] = carton_number
    true
  end


end