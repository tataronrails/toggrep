class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :token_authenticatable

  ALLOWED_FIELDS = %w(api_token email fullname projects workspaces)
  ROLES = %w(worker manager)

  has_one :toggl_user, dependent: :destroy
  has_many :managing_agreements, class_name: 'Agreement', foreign_key: 'manager_id'
  has_many :working_agreements, class_name: 'Agreement', foreign_key: 'worker_id'

  before_update :sync_toggl_user!, :if => :toggl_api_key_changed?

  validates :toggl_api_key,
    presence: true,
    length: {is: 32}

  validates :email,
    presence: true,
    uniqueness: true,
    case_sensitive: false,
    allow_blank: false,
    format: {:with  => Devise.email_regexp}

  def toggl_me_request(with_related_data = false)
    begin
      client = Toggl::Base.new(self.toggl_api_key, self.id)
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

  private

  def sync_toggl_user!
    begin
      toggl_user.sync!(toggl_api_key, self.id)
    rescue Toggl::Forbidden
      false
    end
  end

end