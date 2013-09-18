namespace :png do
  desc "Alert to requisition report and shipment with confirmed status" 
  task :alert => :environment do
    now = Time.now
    Site.alert_requisition_report now.to_date
    Shipment.alert_for_confirm_status now
  end
end  