module TogglFactories

  class << self
    def workspaces(current_user = nil)
      h = []
      3.times do |wid|
        h << TogglWorkspace.new(wid+1, "Workspace #{wid+1}", current_user)
      end
      h
    end

    def workspace_users(wid = nil)
      users = []
      wses = workspaces
      wses.each do |ws|
        next if !wid.blank? && ws.id != wid
        3.times do |e|
          user_id = wses.index(ws) + e + 1
          users << OpenStruct.new({uid: user_id, fullname: "User#{user_id} of #{ws.name}"})
        end
      end
      users
    end

    def workspace_projects(wid)
      projects = []
      3.times do |pid|
        projects << OpenStruct.new({id: pid+1, name: "Project #{pid} of workspace#{wid}", wid: wid})
      end
      projects
    end

    def workspace1_project_users(pid)
      users = workspace_users(1)
      users.each do |e|
        e.pid = pid
        e.uid = 299999 if pid == 3 && users.index(e) == 1
      end
      users
    end

  end

end
