module Admin
  class SmsLogsController < Controller
    load_and_authorize_resource
    
    def index  
      if(params[:shipment_id])
        @shipment = Shipment.find params[:shipment_id]
        @sms_logs = @shipment.sms_logs.of_type(SmsLog::SMS_TYPE_SHIPMENT).paginate(paginate_options)
      elsif params[:site_id]
        @site = Site.find params[:site_id]
        @sms_logs = @site.sms_logs.of_type(SmsLog::SMS_TYPE_REQUISITION).paginate(paginate_options)
      end
    end

    def monitor
      @type = params[:type] || SmsLog::SMS_TYPE_REQUISITION
      @sms_logs = SmsLog.of_type(@type).paginate(paginate_options)
    end

  end
end