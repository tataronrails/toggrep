class TogglWorkspace

  def self.find_name_by_id(user, workspace_id)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    response = client.workspaces
    response.each do |ws|
      return ws.name if ws.id == workspace_id
    end
  end

end
