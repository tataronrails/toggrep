class UsersController < ApplicationController
  def show
    @user = current_user
    @datas = @user.toggl_me_request(true) unless @user.toggl_api_key.blank?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:toggl_api_key)
  end
end
