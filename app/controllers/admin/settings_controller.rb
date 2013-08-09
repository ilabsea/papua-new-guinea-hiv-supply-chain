module Admin
	class SettingsController < Controller
	  def index
      	@app_title = "Settings"  
	  end

	  def create

	  	Setting[:message_alerting_site_about_receiving_form] = params[:setting][:message_alerting_site_about_receiving_form]
	  	Setting[:message_asking_site]  = params[:setting][:message_asking_site]
	  	Setting[:message_deadline]     = params[:setting][:message_deadline]
	  	Setting[:hour]   				 = params[:setting][:hour]
	  	Setting[:date_type] 			 = params[:setting][:date_type]
        
        redirect_to admin_settings_path, notice: 'Setting has been updated successfully.' 

    end
	end
end