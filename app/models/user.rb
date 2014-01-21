class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ALLOWED_FIELDS = %w(api_token email fullname projects workspaces)

  has_one :toggl_user, dependent: :destroy

  before_save :build_toggl_user, :unless => :toggl_user

  before_save :sync_toggl_user!, :if => :toggl_api_key_changed?

  validates :toggl_api_key,
    presence: true,
    length: {is: 32},
    unless: :new_record?

  def toggl_me_request(with_related_data = false)
    begin
      request = Toggl::Base.new(self.toggl_api_key)

      response = request.me(with_related_data)

      response.select { |k,v| ALLOWED_FIELDS.include?(k) }
    rescue

    end
  end

  def to_s
    toggl_user.andand.to_s || email.presence || 'User'
  end

  def self.find_by_toggl_id(id)
    t_user = TogglUser.find_by_uid(id)
    t_user.user if t_user
  end

  private

  def sync_toggl_user!
    toggl_user.sync!(toggl_api_key)
  end

end
