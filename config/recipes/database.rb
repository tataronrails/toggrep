namespace :mysql do
  desc 'Install the latest stable release of mysql.'
  task :install, roles: :db, only: {primary: true} do
    run "#{sudo} apt-get -y install mysql-server"
    run "#{sudo} apt-get -y install mysql-client"
    run "#{sudo} apt-get -y install libmysqlclient-dev"
  end
  after "deploy:install", "mysql:install"

  desc 'Generate the database.yml configuration file.'
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run <<-CPYML
      cp #{release_path}/config/database.yml.sample #{shared_path}/config/database.yml
    CPYML
  end
  after 'deploy:finalize_update', 'mysql:setup'

  desc 'Create a database for this application.'
  task :create_database, roles: :app do
    run <<-CMD
      cd  #{current_path}; bundle exec rake db:create RAILS_ENV=#{rails_env}
    CMD
    #run %Q{#{sudo} rake db:create RAILS_ENV=production}
  end
  #after "deploy:finalize_update", "mysql:create_database"
  before "deploy:migrate", "mysql:create_database"

  desc 'Symlink the database.yml file into latest release'
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"
end