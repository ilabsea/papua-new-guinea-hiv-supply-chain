class Setting < ActiveRecord::Base
 


  KEYS = [
  	{ name: :frequency_hours_to_resend_sms , label: "" , :as => :text },
  	{ name: :frequency_months_to_submit_form , label: "", :as => :text },
  	{ name: :deadline_to_submit_form , label: "", :as => :date_time_picker }
  ]


  MESSAGE_KEYS = [
  	{ name: :message_alerting_site_about_receiving_form, 
  	  label: "" ,
  	  params: %w(site consignment shippening_date)
  	} ,
  	{ name: :message_asking_site, 
  	  label: "", 
  	  params: %w(site consignment shippening_date)  
  	}
  ]	

  def self.[](name)
    setting = Setting.find_by_name(name)
    setting ? setting.value.to_s : ''
  end
  
  
  def self.[]=(name, value)
    setting = Setting.find_by_name(name) || Setting.new(:name => name)
    setting.value = value
    setting.save!
    setting[key]
  end

end
