module Admin
	class SettingsController < Controller
	  def index
	  	@alert_message_value = Setting.find_by_name("message_alerting_site_about_receiving_form") ? Setting.find_by_name("message_alerting_site_about_receiving_form").value : ""
	  	@asking_message_value = Setting.find_by_name("message_asking_site") ? Setting.find_by_name("message_asking_site").value : ""
	  	@deadline_message_value = Setting.find_by_name("message_deadline") ? Setting.find_by_name("message_deadline").value : ""
	  	@hour = Setting.first.hour
	  	@setting = Setting.new
      	@app_title = "Settings"  
	  end

	  def create

	  	message_alert = Setting.find_by_name("message_alerting_site_about_receiving_form")
	  	message_asking = Setting.find_by_name("message_asking_site")
	  	message_deadline = Setting.find_by_name("message_deadline")

	  	if (message_alert)
  			message_alert.update_attributes(:value => params[:setting][:value][0], :hour => params[:setting][:hour])
  		else
  			Setting.create({:name => "message_alerting_site_about_receiving_form", :value => params[:setting][:value][0]}, :hour => params[:setting][:hour])
  		end

  		if (message_asking)
  			message_asking.update_attributes(:value => params[:setting][:value][1], :hour => params[:setting][:hour])
			else
				Setting.create({:name => "message_asking_site", :value => params[:setting][:value][1]}, :hour => params[:setting][:hour])
			end

			if (message_deadline)
				message_deadline.update_attributes(:value => params[:setting][:value][2], :hour => params[:setting][:hour])
			else
				Setting.create({:name => "message_deadline", :value => params[:setting][:value][2]}, :hour => params[:hour][:hour])
			end

      redirect_to admin_settings_path

    end
	end
end