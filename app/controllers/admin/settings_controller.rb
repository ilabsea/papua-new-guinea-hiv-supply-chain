module Admin
  class SettingsController < Controller
    load_and_authorize_resource
    skip_load_resource
    skip_authorize_resource
    
    def index
        @app_title = "Settings"  
    end

    def create
      keys =  [ 
        :message_alerting_site_for_shipment,
        :message_asking_site,
        :message_deadline,
        :hour,
        :date_type,
        :site_message_success, 
        :site_message_error_syntax, 
        :site_message_invalid_consignment_number, 
        :site_message_invalid_status, 
        :site_message_invalid_carton_format, 
        :site_message_invalid_sender
      ]

      keys.each do |key|
        Setting[key] = params[:setting][key]
      end
      redirect_to admin_settings_path, notice: 'Setting has been updated successfully.' 

    end

    def regenerate_cron
      system 'bundle exec whenever --update-crontab png-health-system'
    end
  end
end