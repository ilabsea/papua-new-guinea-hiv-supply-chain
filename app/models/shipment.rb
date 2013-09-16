class Shipment < ActiveRecord::Base
	belongs_to :order
	belongs_to :user
	belongs_to :site
	has_one :order_line

	has_many :shipment_lines, :dependent => :destroy
	has_many :sms_logs, :dependent => :destroy

	attr_accessible :shipment_date, :consignment_number, :status, :user, :received_date, :lost_date

	STATUS_LOST = 'Lost'
	STATUS_RECEIVED = 'Received'
	STATUS_IN_PROGRESS = 'In Progress'

	validates :consignment_number, :shipment_date, :presence => true
	validates :consignment_number, :numericality => true
	validates :user, :presence => true

	default_scope order("shipments.id DESC")

	SHIPMENT_STATUSES = [STATUS_IN_PROGRESS, STATUS_LOST, STATUS_RECEIVED]

	def self.status_mark
		[ [ "Mark as lost", STATUS_LOST] , [ "Mark as received", STATUS_RECEIVED ] ]  	
	end

	def create_shipment shipment_session
		order_lines = OrderLine.find shipment_session.shipment.keys
		shipment_session.shipment.each do |order_line_id, data|
		    options = {  :quantity_issued => data[:quantity], 
						 :order_line_id => order_line_id,
						 :remark => data[:remark],
						 :quantity_suggested => _quantity_suggested(order_lines, order_line_id )
					}	
	
		    shipment_lines.build options
		end
		
		if save
			order_lines.each do |order_line|
				order_line.shipment_status = true
				order_line.save
			end
			return true
		else
			return false	
		end
	end

	def self.bulk_update_status shipments_id, status
		shipments_id.map do|id| 
		  attrs = { :status => status}
		  if status == STATUS_LOST
		  	attrs[:received_date] = nil
		   	attrs[:lost_date] = Time.now
		  elsif status == STATUS_RECEIVED
		  	attrs[:lost_date] = nil
		  	attrs[:received_date] = Time.now
		  end	
		  Shipment.update(id, attrs ) 
		end
	end

	def self.in_between date_start, date_end
	   shipments = where("1=1")

	   if !date_start.blank? && !date_end.blank?
	   	 format     =    '%Y-%m-%d'
	   	 date_start = DateTime.strptime(date_start , format )
	   	 date_end   = DateTime.strptime(date_end   , format )
	     shipments  = shipments.where(['shipment_date BETWEEN :start AND :end', :start => date_start.beginning_of_day, :end => date_end.end_of_day ])
	   end
	   shipments
	end	

	def self.total_shipment_by_status
       shipments = select('COUNT(status) AS total, status').group('status').order('total')
       totals= {}
       shipments.each do |shipment|
       	  totals[shipment.status] = shipment.total.to_i
       end
       totals
  	end

  	def deadline_for? now	
  		if self.site.duration_type == Setting::DURATION_TYPE_DAY
  			now = now.to_date
  			created_date = self.created_at.to_date
  			now > (created_date + self.site.in_every.days)
  		elsif self.site.duration_type == Setting::DURATION_TYPE_HOUR
  			now > self.created_at + self.site.in_every.hours
  		end
  	end

  	def self.alert_for_confirm_status now
  		return true if PublicHoliday.is_holiday?(now.to_date)
	    shipments = Shipment.includes(:site).in_progress
	    shipments.each do |shipment|
	      if shipment.deadline_for? now
	        shipment.alert_deadline
	      end
	    end		
  	end

  	def alert_deadline
  		options = {
	      :site => self.site.name, 
	      :shipment_date => self.shipment_date , 
	      :consignment  => self.consignment_number
	    }

	    setting = Setting[:message_asking_site]
	    translation = setting.str_tr options

	    #send_via_nuntium message_item
	    Sms.send NuntiumMessagingAdapter.instance do |sms|
	      sms.from  = ShipmentSms::APP_NAME
	      sms.to    = 'sms://' + self.site.mobile
	      sms.body  = translation
	    end
	    
	    log = {
	      :site       => self.site,
	      :shipment   => self,
	      :message    => translation,
	      :to         => self.site.mobile,
	      :sms_type   => SmsLog::SMS_TYPE_ASK_CONFIRM
	    }
	    SmsLog.create log
  	end

  	def in_progress?
  		self.status == Shipment::STATUS_IN_PROGRESS
  	end

  	def self.in_progress
  		of_status Shipment::STATUS_IN_PROGRESS
  	end

  	def self.of_status status
  	   where(["status =:status", :status => status ])
  	end

	def _quantity_suggested  order_lines , order_line_id
		order_lines.each do |order_line|
		   return order_line.quantity_suggested if order_line.id == order_line_id
		end
		0
	end
end