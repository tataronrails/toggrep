# RVM bootstrap
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require "whenever/capistrano"

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
load 'config/recipes/mysql'
load 'config/recipes/check'

set :whenever_command, 'bundle exec whenever' #Fixme: Usage?

set :application, 'toggrep'

set :user do
  default_user = 'deploy'
  user = Capistrano::CLI.ui.ask('username (Default is deploy) : ')
  user = default_user if user.empty?
  user
end

set :stages, %w(staging production)
set :default_stage, 'staging'

set :rvm_type, :user

set :deploy_to, "/home/#{user}/#{application}" # Directory in which the deployment will take place
set :deploy_via, :remote_cache
set :use_sudo, false
set :shared_children, shared_children + %w{public/uploads} #Fixme: Usage?

set :ssl_enabled, false
# set :cert_path, "#{current_path}/ssl-certs/SSL.crt"
# set :cert_key_path, "#{current_path}/ssl-certs/ssl.key"

# Source Code Details
set :scm, "git"
set :repository, "git@git.assembla.com:papayaheaderlabs.elderberry.git"

set :branch do
  default_branch = 'master'
  branch = Capistrano::CLI.ui.ask('Branch to deploy (Default:- Master) : ')
  branch = default_branch if branch.empty?
  branch
end

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
