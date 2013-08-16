module Admin
	class SmsLogsController < Controller
		def index
			@shipment = Shipment.find params[:shipment_id]
			@sms_logs = @shipment.sms_logs.paginate(paginate_options)
			@app_title = "Sms logs"
		end

	end
end