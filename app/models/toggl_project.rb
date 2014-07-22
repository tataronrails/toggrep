class TogglProject

  def self.user_projects_by_role(user, role)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    response = client.me(true)
    toggl_projects = response.projects
    toggl_projects.select!(&:active)
    toggl_projects.reduce([]) do |memo, p|
      project_users = client.project_users(p.id)
      project_users.find do |pu|
        if role == 'manager'
          memo << p if pu.uid == user.toggl_user.uid && pu.manager
        end
      end
      memo
    end
  end

  def self.project_users(user, project_id)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    client.project_users(project_id)
  end

end
