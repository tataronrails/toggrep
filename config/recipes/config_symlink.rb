namespace :config_symlink do

  desc 'Generate the email.yml configuration file.'
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run <<-CPYML
      cp #{release_path}/config/email.yml.sample #{shared_path}/config/email.yml
    CPYML
  end
  after 'deploy:finalize_update', 'config_symlink:setup'

  desc 'Symlink the email.yml file into latest release'
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"


end


