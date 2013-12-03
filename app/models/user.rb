class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ALLOWED_FIELDS = %w(api_token email fullname projects workspaces)

  def toggl_me_request(with_related_data = false)
    begin
      request = Toggl::Base.new(self.toggl_api_key)

      response = request.me(with_related_data)

      response.select { |k,v| ALLOWED_FIELDS.include?(k) }
    rescue

    end
  end
end
