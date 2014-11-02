# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{deployer@198.58.117.55}
role :web, %w{deployer@198.58.117.55}
role :db,  %w{deployer@198.58.117.55}
# role :resque_worker, '198.58.117.55'
# role :resque_scheduler, '198.58.117.55'

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '198.58.117.55', user: 'deployer', roles: %w{web app db}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

# Specify the server that Resque will be deployed on. If you are using Cap v3
# and have multiple stages with different Resque requirements for each, then
# these __must__ be set inside of the applicable config/deploy/... stage files
# instead of config/deploy.rb:

# set :workers, { 'simple' => 1, 'mailer' => 1 }

# We default to storing PID files in a tmp/pids folder in your shared path, but
# you can customize it here (make sure to use a full path). The path will be
# created before starting workers if it doesn't already exist.
# set :resque_pid_path, -> { File.join(shared_path, 'pids') }

# Uncomment this line if your workers need access to the Rails environment:
# set :resque_environment_task, true
