class ShipmentSms < Sms

  APP_NAME	= "Health supply chain"

  def initialize shipment
  	@shipment = shipment
  end

  def alert
  	options = {
  		:site => @shipment.site.name, 
  		:consignment => @shipment.consignment_number , 
  		:shippening_date =>  @shipment.shipment_date
  	}

  	setting = Setting[:message_alerting_site_about_receiving_form]
  	translation = setting.str_tr options

    #send_via_nuntium message_item
    Sms.send NuntiumMessagingAdapter.instance do |sms|
      sms.from  = ShipmentSms::APP_NAME
      sms.to    = 'sms://' + @shipment.site.mobile
      sms.body  = translation
    end
    

  	log = {
  		:site 	 	  => @shipment.site,
  		:shipment 	=> @shipment,
  		:message    => translation,
  		:to 		    => @shipment.site.mobile
  	}

  	SmsLog.create log

  	@shipment.last_notified_date = Time.now
  	@shipment.save

  end

end