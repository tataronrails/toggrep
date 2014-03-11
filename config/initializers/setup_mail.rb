if Rails.env != 'test'
  Toggrep::EMAIL = email_settings = YAML::load(File.open(Rails.root.join('config/email.yml')))[Rails.env]

  available_attributes = %w(delivery_method raise_delivery_errors smtp_settings default_url_options)

  if email_settings.present?
    available_attributes.each do |attribute|
      if email_settings.key?(attribute)
        ActionMailer::Base.send(attribute + '=', email_settings[attribute])
      end
    end
  end
end