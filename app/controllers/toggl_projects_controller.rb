class TogglProjectsController < ApplicationController

  def project_users
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

  def projects
    toggl_projects = TogglProject.user_projects_by_role(current_user, 'manager')
    projects = toggl_projects.map{ |p| p.slice(:name, :id, :wid).to_hash }
    api_key = current_user.toggl_api_key
    response = projects.reduce({}) do |memo, p|
      w_name = TogglWorkspace.find_name_by_id(api_key, p['wid'])
      memo[w_name] ||= []
      memo[w_name] << p.slice('id', 'name')
      memo
    end
    respond_to do |format|
      format.json { render json: response.to_a }
    end
  end

end