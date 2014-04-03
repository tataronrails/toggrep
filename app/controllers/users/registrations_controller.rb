class Users::RegistrationsController < Devise::RegistrationsController

private

  def build_resource(attrs=nil)
    self.resource = if attrs[:toggl_api_key].present?
      user = User.new(toggl_api_key: attrs[:toggl_api_key])
      user.build_toggl_user
      user.toggl_user.sync
      user.email = user.toggl_user.email
      user
    else
      User.new
    end
  end

  def sign_up_params
    params.require(:user).permit(:toggl_api_key)
  end

end