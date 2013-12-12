require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  Resque.schedule = YAML.load_file(Rails.root.join("config/rescue_schedule.yml"))
  ENV['QUEUE'] = '*'
end