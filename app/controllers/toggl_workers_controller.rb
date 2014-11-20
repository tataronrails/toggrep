class TogglWorkersController < ApplicationController

  def index
    @workspaces = current_user.toggl_user.workspaces
  end
end
