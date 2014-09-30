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

# for warden, `:token_authenticatable`` is just a name to identify the strategy
Warden::Strategies.add :token_authenticatable, TokenAuthenticatable::CustomAuth

# for devise, there must be a module named 'TokenAuthenticatable' (name.to_s.classify), and then it looks to warden
# for that strategy. This strategy will only be enabled for models using devise and `:token_authenticatable` as an
# option in the `devise` class method within the model.
Devise.add_module :token_authenticatable, :strategy => true