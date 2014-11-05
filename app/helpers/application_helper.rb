module ApplicationHelper

  def external_toggl_workspace_path(workspace)
    "https://www.toggl.com/app/workspaces/edit/#{workspace.id}"
  end

end
