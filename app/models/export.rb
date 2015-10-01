# encoding: utf-8
require 'csv'
class Export 
  def self.order file, type
    CSV.open(file, "wb") do |csv|
      headers = ['Summition', 'Site',  'Id', 'Order Creation','Entry', 'Reviewer', 'Reviewed Date', 'Status']
      csv << headers
      orders = type.blank? ? Order : Order.of_status(type)
      orders.find_each do |order|
        csv << [ order.date_submittion, 
             order.site.name,
             order.id,
             show_date(order.order_date),
             order.user_data_entry ? order.user_data_entry.user_name : "",
             order.review_user ?  order.review_user.user_name : "",
             show_date_time(order.review_date),
             order.status 
        ]
      end
    end
  end

  def self.shipment file, type
    CSV.open(file, "wb") do |csv|
      headers = ['Site', 'Consignment', 'Cost', 'Carton', 'Status','Date Shipped', 'SMS Notified clinic (times)', 'Last notified date to clinic', 'Received date', 'Package lost', 'Sms']
      csv << headers
      shipments = type.blank? ? Shipment : Shipment.of_status(type)
      shipments.find_each do |shipment|
        row = [
          shipment.site.name,
          shipment.consignment_number,
          shipment.cost,
          shipment.carton,
          shipment.status,
          show_date(shipment.shipment_date),
          shipment.sms_logs_count,
          show_date_time(shipment.last_notified_date),
          show_date_time(shipment.received_date),
          show_date_time(shipment.lost_date),
          shipment.site_messages_count
        ]
        csv << row
      end
    end
  end

  def self.show_date(date)
    date ? date.strftime(ENV['DATE_FORMAT']) : ''
  end

  def self.show_date_time(datetime)
    datetime ? datetime.strftime(ENV['DATE_TIME_FORMAT']) : ''
  end

end