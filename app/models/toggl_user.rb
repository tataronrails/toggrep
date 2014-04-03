class TogglUser < ActiveRecord::Base

  belongs_to :user, inverse_of: :toggl_user

  def to_s
    fullname.presence || email.presence
  end

  def sync
    client = Toggl::Base.new(user.toggl_api_key)
    response = client.me
    datas = response.slice(:id, :email, :fullname)
    datas[:uid] = datas[:id]
    datas.delete(:id)
    attrs = ActionController::Parameters.new(datas).permit(
        %w(uid email fullname)
    )
    assign_attributes(attrs)
  end

  def sync!(toggl_api_key)
    client = Toggl::Base.new(toggl_api_key)
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
