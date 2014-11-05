class TogglWorkspacesController < ApplicationController

  def index
    @user_workspaces = TogglWorkspace.user_workspaces(current_user)
  end

end
