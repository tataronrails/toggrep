class SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(:database_authenticatable, :token_authenticatable, :rememberable)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
    unless warden.authenticated?
      set_flash_message(:alert, :unauthenticated) if is_flashing_format?
      redirect_to new_user_session_path
    end
  end

end