class Setting < ActiveRecord::Base
 
  attr_accessible :value, :name, :hour

  DURATION_TYPE_HOUR = "Hour"
  DURATION_TYPE_DAY  = "Day"
  DURATION_TYPES     = [DURATION_TYPE_HOUR, DURATION_TYPE_DAY]

  KEYS = [
  	{ name: :frequency_hours_to_resend_sms , label: "" , :as => :text },
  	{ name: :frequency_months_to_submit_form , label: "", :as => :text },
  	{ name: :deadline_to_submit_form , label: "", :as => :date_time_picker }
  ]


  MESSAGE_KEYS = [
  	{ name: :message_alerting_site_about_receiving_form, 
  	  label: "Message notification of package deliver to site" ,
  	  params: %w(site consignment shippening_date)
  	} ,
  	{ name: :message_asking_site, 
  	  label: "Message check for confirmation of receiving package to site", 
  	  params: %w(site consignment shippening_date)  
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

  def self.create_or_update_message_alert message_alert, params
    if (message_alert)
        message_alert.update_attributes(:value => params[:setting][:value][0])
    else
      Setting.create({:name => "message_alerting_site_about_receiving_form", :value => params[:setting][:value][0]})
    end
  end

  def self.create_or_update_message_asking message_asking, params
    if (message_asking)
        message_asking.update_attributes(:value => params[:setting][:value][1])
    else
      Setting.create({:name => "message_asking_site", :value => params[:setting][:value][1]})
    end
  end

  def self.create_or_update_message_deadline message_deadline, params
    if (message_deadline)
      message_deadline.update_attributes(:value => params[:setting][:value][2])
    else
      Setting.create({:name => "message_deadline", :value => params[:setting][:value][2]})
    end
  end

  def self.create_or_update_frequency_hour frequency_hour, params
    if (frequency_hour)
      frequency_hour.update_attributes(:value => params[:setting][:hour])
    else  
      Setting.create({:name => "hour", :value => params[:setting][:hour]})
    end
  end

end
