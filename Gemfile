source 'https://rubygems.org'

gem 'rails', '~> 4.0.0'
gem 'haml'
gem 'devise'
gem 'simple_form'
gem 'toggl_api'
gem 'rails_admin'
gem 'cancancan'
gem 'faraday', '~> 0.8.7'
gem 'awesome_print', '~> 1.1.0'
gem 'semantic-ui-sass', '~> 0.15.5.0'
gem 'font-awesome-rails'
gem 'high_voltage'
gem 'state_machine'
gem 'andand'
gem 'select2-rails'
gem 'resque'
gem 'resque_mailer'
gem 'resque-scheduler'
gem 'redis-server'
gem 'inherited_resources',
    github: 'josevalim/inherited_resources',
    ref: '5b61f8a58ab39ea8be11435e750ea90c6a5925af'
gem 'has_scope',
    github: 'plataformatec/has_scope',
    ref: 'b62cea0d810f019f1a89a92da068f37077727662'

gem 'sqlite3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-zeus'
  gem 'guard-rspec', require: false
  gem 'guard-livereload', require: false

  # Pronto environment
  gem 'pronto', require: false
  gem 'pronto-rubocop', require: false
  gem 'pronto-flay', require: false
  gem 'pronto-rails_best_practices', require: false
  gem 'pronto-brakeman', require: false

  #Deployment Tools
  gem 'capistrano', '~> 2.15.5'
  gem 'rvm-capistrano'
  gem 'capistrano-ext'
  gem 'net-ssh'

end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails', require: false
  gem 'faker'
  gem 'fuubar'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production, :staging do
  gem 'unicorn'
end


