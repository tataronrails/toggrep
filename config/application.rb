require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Toggrep
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en

    config.generators do |g|
      g.factory_girl true
    end

    ### ExceptionNotification
    unless Rails.env.development?
      config.middleware.use ExceptionNotification::Rack, email: {
          email_prefix: "[Toggrep] [#{Rails.env}] ",
          :sender_address => %{'Exception Notifier' <no-reply@Toggrep.com>},
          :exception_recipients => %w{rajeevsharma86@gmail.com},
          delivery_method: :smtp,
          smtp_settings: {
              address: 'smtp.gmail.com',
              port: 587,
              user_name: 'tataronrails2@gmail.com',
              password: 'tataruby',
              authentication: :plain,
              enable_starttls_auto: true
          }
      }
    end


  end
end
