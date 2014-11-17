class PasswordsController < Devise::PasswordsController

  def create
    user = User.find_by_email(params[:user][:email])
    if user.blank?
      set_flash_message(:alert, :unsigned_up)
      redirect_to action: :new
      return
    end
    super
  end

end
