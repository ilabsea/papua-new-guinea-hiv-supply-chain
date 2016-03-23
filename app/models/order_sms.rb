class OrderSms < Sms

  def initialize order
    @order = order
  end

  def alert
    options = {
      :order_number => @order.order_number,
      :site => @order.site.name ,
      :submission_date =>  @order.date_submittion,
      :approved_by => @order.approved_user.try(:display_name),
      :approved_at => @order.approved_at
    }

    setting = Setting[:message_alerting_site_for_approved_order]
    translation = setting.str_tr options

    #send_via_nuntium message_item
    Sms.instance.send(
                       to: @order.site.mobile.with_sms_protocol,
                       body: translation )


    log = {
      :site    => @order.site,
      :message    => translation,
      :to         => @order.site.mobile,
      :sms_type   => SmsLog::SMS_TYPE_ORDER_APPROVED
    }

    SmsLog.create log
  end

end
