class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @workspaces = current_user.workspaces
  end
end
