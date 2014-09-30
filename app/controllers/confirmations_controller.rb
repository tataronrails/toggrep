class ConfirmationsController < Devise::ConfirmationsController

	def show
    self.resource = confirm_and_reset_pass(params[:confirmation_token])
    yield resource if block_given?
    if resource
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_with_navigational(resource){redirect_to after_confirmation_path_for(resource_name, resource)}
    else
      set_flash_message(:alert, :invalid_confirmation_key) if is_flashing_format?
      redirect_to new_user_confirmation_path
    end
	end

private

	def after_confirmation_path_for(resource_name, resource)
    edit_password_path(resource, :reset_password_token => params[:confirmation_token])
  end

  def confirm_and_reset_pass(token)
    original_token     = token
    confirmation_token = Devise.token_generator.digest(self, :confirmation_token, token)
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, token)
    confirmable = User.find_by(confirmation_token: confirmation_token)
    if confirmable
      confirmable.reset_password_token = reset_password_token
      confirmable.reset_password_sent_at = Time.now.utc
      confirmable.confirm! if confirmable.persisted?
      confirmable.confirmation_token = confirmation_token
      confirmable
    else
      return nil
    end
  end

end
