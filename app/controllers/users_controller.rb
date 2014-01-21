class UsersController < ApplicationController

  load_resource :except => :show
  authorize_resource

  def show
    @user = User.find(params[:id])
    @datas = @user.toggl_me_request(true) unless @user.toggl_api_key.blank?
    @workspaces = []
    if @datas.present? && @datas['workspaces'].any?
      @datas['workspaces'].each do |workspace|
        projects = []
        @datas['projects'].each do |project|
          projects << project.name if project.wid == workspace.id
        end
        @workspaces << Hashie::Mash.new(name: workspace.name, projects: projects)
      end
    end
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
