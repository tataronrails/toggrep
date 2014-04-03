class Users::RegistrationsController < Devise::RegistrationsController

private

  def build_resource(hash=nil)
    self.resource = if hash[:toggl_api_key].present?
      user = User.new(toggl_api_key: hash[:toggl_api_key])
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