class RegistrationsController < Devise::RegistrationsController

  def new
    build_resource({})
  end

  def create
    begin
      @user = User.find_by!(toggl_api_key: get_toggl_data[:toggl_api_key])
      sign_in @user
      if user_signed_in?
        set_flash_message(:notice, :exists) if is_flashing_format?
      end
      redirect_to root_path

      rescue Toggl::Forbidden
        set_flash_message(:alert, :rejected) if is_flashing_format?
        redirect_to new_user_registration_path
      return

      rescue ActiveRecord::RecordNotFound
        build_resource(get_toggl_data)
        resource.save
        yield resource if block_given?
        if resource.active_for_authentication?
          set_flash_message(:notice, :signed_up) if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message(:notice, :"signed_up_but_#{resource.inactive_message}") if is_flashing_format?
          expire_data_after_sign_in!
          redirect_to new_user_confirmation_path
        end
      return
    end
  end

private

  def sign_up_params
    params.require(:user).permit(:toggl_api_key)
  end

  def get_toggl_data
    client = Toggl::Base.new(params[:user][:toggl_api_key], 'api_token')
    response = client.me(true)
    user_email = response.email
    user_toggl_api_key = response.api_token
    { email: user_email, toggl_api_key: user_toggl_api_key }
  end

end