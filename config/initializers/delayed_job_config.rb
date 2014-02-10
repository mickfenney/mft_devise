Delayed::Worker.max_attempts = 5
#Delayed::Worker.delay_jobs = !Rails.env.test?

Delayed::Worker.logger = Logger.new("#{Rails.root}/log/delayed_job.log", 20, 1048576)
if caller.last =~ /script\/delayed_job/ or (File.basename($0) == "rake" and ARGV[0] =~ /jobs\:work/)
  ActiveRecord::Base.logger = Delayed::Worker.logger
end