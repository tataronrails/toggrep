class TogglUser < ActiveRecord::Base

  belongs_to :user

  def to_s
    fullname.presence || email.presence || 'User'
  end

  def sync!(user)
    client = Toggl::Base.new(user.toggl_api_key, user.id)
    response = client.me
    datas = response.slice(:id, :email, :fullname)
    datas[:uid] = datas[:id]
    datas.delete(:id)
    attrs = ActionController::Parameters.new(datas).permit(
      %w(uid email fullname)
    )
    update_attributes(attrs)
  end

end
