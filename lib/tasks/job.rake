namespace :job do
  desc "Job queue " 
  task :alert_site => :environment do
  	p "\n\r running task"
    date = Time.now.to_date
    Site.alert date
    p "\n\r task done"
  end
end  