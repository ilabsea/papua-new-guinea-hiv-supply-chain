module Admin
	class SettingsController < Controller
	  def index
	  	@alert_message_value = Setting["message_alerting_site_about_receiving_form"]
	  	@asking_message_value = Setting["message_asking_site"]
	  	@deadline_message_value = Setting["message_deadline"]
	  	@hour = Setting["hour"]
	  	@setting = Setting.new
      	@app_title = "Settings"  
	  end

	  def create

	  	message_alert = Setting.find_by_name("message_alerting_site_about_receiving_form")
	  	message_asking = Setting.find_by_name("message_asking_site")
	  	message_deadline = Setting.find_by_name("message_deadline")
	  	frequency_hour = Setting.find_by_name("hour")

	  	Setting.create_or_update_message_alert(message_alert, params)
	  	Setting.create_or_update_message_asking(message_asking, params)
	  	Setting.create_or_update_message_deadline(message_deadline, params)
	  	Setting.create_or_update_frequency_hour(frequency_hour, params)

      redirect_to admin_settings_path, notice: 'Setting was successfully updated.' 

    end
	end
end