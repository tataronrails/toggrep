# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'toggrep'
set :repo_url, 'git@github.com:tataronrails/toggrep.git'

set :stages, %w(staging production)
set :default_stage, 'production'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :user, :deployer
set :deploy_to, "/home/#{fetch(:user)}/www/apps/toggrep"
set :ruby_version, '2.0.0'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :branch, 'vl/feature/deploy'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %W{config/database.yml
                      config/email.yml
                      db/#{fetch(:stage)}.sqlite3}


# Default value for linked_dirs is []
set :linked_dirs, %w{bin log}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
    invoke 'resque:restart'
  end
  # make sure we're deploying what we think we're deploying

  # before :deploy, "deploy:check_revision"

  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  # before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  # after 'deploy:setup_config', 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'

  after :finishing, :restart
end
