class Setting < ActiveRecord::Base
 
  attr_accessible :value, :name, :hour

  DURATION_TYPE_HOUR = "Hour(s)"
  DURATION_TYPE_DAY  = "Day(s)"
  DURATION_TYPES     = [DURATION_TYPE_HOUR, DURATION_TYPE_DAY]

  KEYS = [
  	{ name: :frequency_hours_to_resend_sms , label: "" , :as => :text },
  	{ name: :frequency_months_to_submit_form , label: "", :as => :text },
  	{ name: :deadline_to_submit_form , label: "", :as => :date_time_picker }
  ]


  MESSAGE_KEYS = [
  	{ name: :message_alerting_site_about_receiving_form, 
  	  label: "Message notification of package deliver to site" ,
  	  params: %w(site consignment shipment_date )
  	} ,
  	{ name: :message_asking_site, 
  	  label: "Message check for confirmation of receiving package to site", 
  	  params: %w(site consignment shipment_date)  
  	},
    { name: :message_deadline, 
      label: "Message reminder to site who did not submit requisition form by deadline", 
      params: %w(site deadline_date)  
    }
  ]

  def self.[](name)
    setting = get_setting name
    setting ? setting.value.to_s : ''
  end
  
  def self.get_setting name
     @settings ||= Setting.all
     @settings.select{|s| s.name.to_s == name.to_s }.first
  end

  def self.[]=(name, value)
    setting = Setting.find_by_name(name) || Setting.new(:name => name)
    setting.value = value
    setting.save!
    @settings = nil
    value
  end

end
