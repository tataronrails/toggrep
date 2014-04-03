class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    @original_token = params[:confirmation_token]
    digested_token = Devise.token_generator.digest(self, :confirmation_token, params[:confirmation_token])
    self.resource = User.find_by_confirmation_token(digested_token) if params[:confirmation_token].present?
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    digested_token = params[:user][:confirmation_token]
    self.resource = User.find_by(confirmation_token: digested_token) if params[:user][:confirmation_token].present?
    if resource.update_attributes(params[:user].except(:confirmation_token).permit(:email, :password, :password_confirmation)) && resource.password_match?
      self.resource.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(:user, resource)
    else
      render action: 'show'
    end
  end

end