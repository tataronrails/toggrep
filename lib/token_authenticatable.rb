module TokenAuthenticatable
  class CustomAuth < Devise::Strategies::Authenticatable

    def authenticate!
      resource = User.find_by!(toggl_api_key: params[scope][:toggl_api_key])
      if resource
         success!(resource)
      end
      rescue ActiveRecord::RecordNotFound
      fail(:token_not_found_in_database)
      return
    end

  end
end

Warden::Strategies.add :token_authenticatable, TokenAuthenticatable::CustomAuth
Devise.add_module :token_authenticatable, strategy: true