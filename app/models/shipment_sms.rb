class ShipmentSms < Sms
  
  def initialize shipment
    @shipment = shipment
  end

  def alert
    options = {
      :site => @shipment.site.name, 
      :consignment => @shipment.consignment_number , 
      :shipment_date =>  @shipment.shipment_date,
      :carton_number => @shipment.carton
    }

    setting = Setting[:message_alerting_site_for_shipment]
    translation = setting.str_tr options

    #send_via_nuntium message_item
    Sms.send NuntiumMessagingAdapter.instance do |sms|
      sms.from  = ShipmentSms::APP_NAME
      sms.to    = @shipment.site.mobile.with_sms_protocol
      sms.body  = translation
    end
    

    log = {
      :site        => @shipment.site,
      :shipment   => @shipment,
      :message    => translation,
      :to         => @shipment.site.mobile,
      :sms_type   => SmsLog::SMS_TYPE_SHIPMENT
    }

    SmsLog.create log

    @shipment.last_notified_date = Time.now
    @shipment.save

  end

end