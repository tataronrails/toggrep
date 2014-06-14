class SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)
    if current_user
      sign_in(resource_name, resource)
      unless toggle_api_key_is_correct?
        set_flash_message(:alert, :wrong_toggl_api_key) if is_flashing_format?
        redirect_to edit_user_path(current_user, incorrect_api_key: true)
        return
      end
    end
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

private

  def toggle_api_key_is_correct?
    begin
      client = Toggl::Base.new(current_user.toggl_api_key)
      client.me
      return true
    rescue Toggl::Forbidden
      false
    end
  end
end
