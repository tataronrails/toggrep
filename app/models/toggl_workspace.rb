class TogglWorkspace

  attr_accessor :id, :name, :users

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
    end
  end

  def self.user_workspaces(user)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    client.workspaces
  end

  def initialize(id = nil, name = nil, current_user = nil, build_users = false)
    @id, @name, @users = id, name, nil
    @toggl_client = Toggl::Base.new(current_user.toggl_api_key, current_user.id) if current_user
    @users = get_users_with_projects if build_users
  end

  def get_users_with_projects
    u_arr = []
    users = @toggl_client.get_relations_of_workspace_and_user @id
    w_projects = @toggl_client.get_workspace_projects @id
    users.each do |u|
      u.projects = []
      w_projects.each do |p|
        user_projects = @toggl_client.project_users p.id
        user_projects.each do |pu|
          if u.uid == pu.uid
            u.projects << p
          end
        end
      end
      u_arr << u
    end
    u_arr
  rescue Toggl::Forbidden, Toggl::InternalServerError, Toggl::Unauthorized
    []
  end



end
