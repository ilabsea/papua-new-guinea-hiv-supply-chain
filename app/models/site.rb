class Site < ActiveRecord::Base
  belongs_to :province
  attr_accessible :address, :contact_name, :email, :in_every, :duration_type,
                  :land_line_number, :lat, :lng, :mobile, 
                  :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
                  :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id

  
  validates :contact_name,:land_line_number, :mobile, :name, :number_of_deadline_sumission, :order_frequency, :order_start_at, 
            :service_type, :suggestion_order, :test_kit_waste_acceptable, :province_id , :presence   =>  true

  validates :order_frequency, :number_of_deadline_sumission, :numericality => {:greater_than => 0}    
  validates  :suggestion_order, :test_kit_waste_acceptable,  :numericality => {:greater_than_or_equal_to => 0 }      
     
  
  SeviceType = ["ART", "VCCT"]
  default_scope order('sites.name ASC')

  has_many :users
  has_many :requisition_reports
  has_many :orders
  has_many :surv_sites
  has_many :sms_logs


  def deadline_date
    self.order_start_at + self.order_frequency.months + self.number_of_deadline_sumission.days
  end


  def deadline_for? now
    if(now > self.deadline_date )
      requisitions = self.requisition_reports.where(["requisition_reports.created_at BETWEEN :start AND :deadline", 
                                                     :start => self.order_start_at.beginning_of_day, :deadline => self.deadline_date.end_of_day])
      return true if requisitions.size == 0
    end
    return false
  end

  def self.alert now
    return true if PublicHoliday.is_holiday?(now)
    sites = Site.all
    sites.each do |site|
      if site.deadline_for? site
        site.alert_dead_line_for now
      end
    end
  end

  def alert_dead_line_for now

    options = {
      :site => self.name, 
      :deadline_date => self.deadline_date , 
    }

    setting = Setting[:message_deadline]
    translation = setting.str_tr options

    #send_via_nuntium message_item
    Sms.send NuntiumMessagingAdapter.instance do |sms|
      sms.from  = ShipmentSms::APP_NAME
      sms.to    = 'sms://' + self.mobile
      sms.body  = translation
    end
    
    log = {
      :site       => self,
      :shipment   => nil,
      :message    => translation,
      :to         => self.mobile,
      :sms_type   => SmsLog::SMS_TYPE_REQUISITION
    }
    SmsLog.create log
  end

end
