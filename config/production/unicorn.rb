app = 'toggrep'
user = 'deployer'
root = "/home/#{user}/www/apps/#{app}/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/home/#{user}/www/apps/#{app}/shared/unicorn.sock"
# listen socket_file, :backlog => 1024
worker_processes 1
timeout 30
