# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{path}/log/cron.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require File.expand_path('../environment', __FILE__)

# number    = Setting[:hour].to_i
# date_type = Setting[:date_type]

# p "Regenerate cron for #{number}(#{date_type})"

every 1.hour do
  rake "png:alert"
end

every 1.day do
  rake "png:backup_db"
end

# if date_type == Setting::DURATION_TYPE_HOUR
# 	every number.hours do
# 	  rake "png_job:alert"
# 	end

# elsif date_type == Setting::DURATION_TYPE_DAY
# 	every number.days do
# 	  rake "png_job:alert"
# 	end
# end
