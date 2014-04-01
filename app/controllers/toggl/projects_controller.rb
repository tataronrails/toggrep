class Toggl::ProjectsController < ApplicationController

  def index
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