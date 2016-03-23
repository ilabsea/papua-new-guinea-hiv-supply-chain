namespace :png do
  desc "Alert to requisition report and shipment with confirmed status"
  task :alert => :environment do
    now = Time.zone.now

    Rails.logger.info("Alert requisition report for #{now.to_date}")
    Site.alert_requisition_report now.to_date

    Rails.logger.info("Alert shipment confirm status for #{now}")
    Shipment.alert_for_confirm_status now
  end

  desc "Backup data every day"
  task backup_db: :environment do
    BackupDb.process
  end

  desc "Update total order"
  task total_order: :environment do
    Site.all.each do |site|
      site.orders_count = site.orders.length
      site.save
    end
  end
end
