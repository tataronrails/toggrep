class TogglUser < ActiveRecord::Base

  belongs_to :user

  def to_s
    fullname.presence || email.presence || 'User'
  end

  def sync!(toggl_api_key)
    client = Toggl::Base.new(toggl_api_key)
    response = client.me
    datas = response.slice(:id, :email, :fullname)
    datas[:uid] = datas[:id]
    datas.delete(:id)
    update_attributes(datas)
  end

end
