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
      client = Toggl::Base.new(self.toggl_api_key)
      response = client.me(with_related_data)
      response.select { |k,v| ALLOWED_FIELDS.include?(k) }
    rescue StandardError
    end
  end

  def should_be_checked?(violation_rule, agreement)
    last_check = ViolationCheck.where(violation_rule: violation_rule, agreement: agreement).last
    if last_check
      need_time = instance_eval(violation_rule.assert_each)
      time_has_passed = (Time.now - last_check.created_at)
      time_has_passed > need_time
    else
      true
    end
  end

  def to_s
    toggl_user.andand.to_s || email.presence || 'User'
  end

  def self.find_by_toggl_id(id)
    TogglUser.find_by_uid(id).andand.user
  end

  def time_entries
    client = Toggl::Base.new(toggl_api_key)
    entries = []
    response = client.me(true)
    response.time_entries.presence.each do |field|
      field.select!{ |k,v| entries << v if %w(stop).include?(k) && field['duration'] > 0 }
    end
    entries
  end

  private

  def sync_toggl_user!
    toggl_user.sync!(toggl_api_key)
  end

end
