namespace :job do
  desc "Job queue " 
  task :alert_site => :environment do
    date = Time.now.to_date
    Site.alert date
  end
end  