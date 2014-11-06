require 'bundler/capistrano'

# set :whenever_command, "bundle exec whenever"

# require "whenever/capistrano"

server '178.62.155.118', :web, :app, :db, primary: true
set :application, 'toggrep'
set :user, 'deployer'
set :deploy_to, "/home/#{user}/www/apps/#{application}"
set :rails_env, 'production'
set :deploy_via, :remote_cache
set :use_sudo, false
# set :port, 60321
set :scm, :git
set :repository, 'git@bitbucket.org:ivcheg/tmptracking.git'
set :branch, 'master'
set :domain, "#{user}@178.62.155.118"
set :shared_children, shared_children + %w{public/uploads}
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :default_environment, {
    'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/production/nginx.conf /etc/nginx/sites-enabled/#{application}.conf"
    sudo "ln -nfs #{current_path}/config/production/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
  end
  after 'deploy:finalize_update', 'deploy:symlink_config'

  desc 'Make sure local git is in sync with remote.'
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts "Run `git push` to sync changes."
      exit
    end
  end

  desc 'Start websocket'
  task :websocket_start, roles: :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake websocket_rails:start_server"
  end

  desc 'Stop websocket'
  task :websocket_stop, roles: :app do
    # run "cd #{current_path}; RAILS_ENV=production bundle exec rake websocket_rails:stop_server"
    pid_file =  "#{current_path}/tmp/pids/websocket_rails.pid"
    run "if [ -d #{current_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{current_path} && RAILS_ENV=production bundle exec rake websocket_rails:stop_server; else echo 'Websocket rails is not running'; fi"
  end


  before 'deploy',          'deploy:websocket_stop'
  after 'deploy',           'deploy:websocket_start'

  before 'deploy', 'deploy:check_revision'

end

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases
