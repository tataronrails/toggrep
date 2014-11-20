class TogglUser < ActiveRecord::Base

  attr_accessor :toggl_client

  belongs_to :user
  after_find :build_toggl_client
  after_initialize :build_toggl_collections

  def to_s
    fullname.presence || email.presence || 'User'
  end

  def sync!(api_key = nil)
    build_toggl_client unless api_key
    response = @toggl_client.me
    datas = response.slice(:id, :email, :fullname)
    datas[:uid] = datas[:id]
    datas.delete(:id)
    attrs = ActionController::Parameters.new(datas).permit(
      %w(uid email fullname)
    )
    assign_attributes(attrs)
  end

  def workspaces(fetch = false)
    if fetch || @workspaces.blank?
      @workspaces.clear
      @toggl_client.workspaces.each do |ws|
        @workspaces << TogglWorkspace.new(ws.id, ws.name, self.user, true)
      end
    end
    @workspaces
  rescue Toggl::Forbidden, Toggl::InternalServerError, Toggl::Unauthorized
    []
  end

  private

  def build_toggl_client(api_key = nil)
    unless api_key
      @toggl_client = Toggl::Base.new(user.toggl_api_key, user.id)
    else
      @toggl_client = Toggl::Base.new(api_key, nil)
    end
  end

  def build_toggl_collections
    @workspaces = []
  end

end
