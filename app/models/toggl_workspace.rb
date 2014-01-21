class TogglWorkspace

  def self.find_name_by_id(api_key, workspace_id)
    client = Toggl::Base.new(api_key)
    response = client.workspaces
    response.each do |ws|
      return ws.name if ws.id == workspace_id
    end
  end

end