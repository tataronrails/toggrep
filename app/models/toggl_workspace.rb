class TogglWorkspace

  def self.find_name_by_id(user, workspace_id)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    response = client.workspaces
    response.each do |ws|
      return ws.name if ws.id == workspace_id
    end
  end

  def self.extract_workspaces_with_projects(datas)
    datas.andand['workspaces'].reduce([]) do |memo_workspaces, workspace|
      projects = datas.andand['projects'].reduce([]) do |memo_projects, project|
        if project.wid == workspace.id
          memo_projects << project.name
        end
        memo_projects.uniq!
        memo_projects
      end
      memo_workspaces << Hashie::Mash.new(name: workspace.name, projects: projects)
    end if datas.andand['projects'].present?
  end

  def self.user_workspaces(user)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    client.workspaces
  end

end
