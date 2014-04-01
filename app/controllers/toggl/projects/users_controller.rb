class Toggl::Projects::UsersController < ApplicationController

  def index
    api_key = current_user.toggl_api_key
    toggl_project_users = TogglProject.project_users(api_key, params[:project_id])
    users = toggl_project_users.reduce({}) do |memo, pu|
      user = User.find_by_toggl_id(pu.uid)
      memo[user.id] = user.toggl_user.fullname if user
      memo
    end
    respond_to do |format|
      format.json { render json: users }
    end
  end

end