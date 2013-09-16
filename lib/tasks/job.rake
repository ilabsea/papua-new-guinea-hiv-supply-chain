namespace :png_job do
  desc "Job queue " 
  task :alert => :environment do
  	p "\n\r running task alert requisition report"
    now = Time.now
    Site.alert_requisition_report now.to_date
    p "\n\r task alert requisition done"

    p "\n\n running task alert shipment confirmation status"
    Shipment.alert_for_confirm_status now
    p "\n\n task alert shipement done"
  end
end  