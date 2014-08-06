class Agreement < ActiveRecord::Base

  STATES = %w(
    proposed
    changed_by_worker
    changed_by_manager
    rejected
    accepted
    canceled
  )

  FILTERS = %w(
    all
    newest
    discussing
    current
    past
  )

  belongs_to :manager, class_name: User
  belongs_to :worker, class_name: User
  has_many :violation_checks

  validates :limit_min, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :limit_max, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates_presence_of :manager_id
  validates_presence_of :worker_id

  default_scope order('started_at ASC')

  scope :current, -> {
    where('? between started_at and ended_at', Date.today)
  }
  scope :past, -> {
    where('started_at and ended_at < ?', Date.today)
  }
  scope :discussing, -> {
    where(state: :changed_by_worker)
  }
  scope :newest, -> {
    where(state: :proposed)
  }
  scope :user_agreements, -> (user) {
    where('manager_id OR worker_id = ?', user)
  }

  state_machine :state, :initial => :proposed do
    after_transition  do |agreement, transition|
      agreement.notify_users transition
    end

    event :accept do
      transition [:proposed, :changed_by_worker, :changed_by_manager] => :accepted
    end

    event :reject do
      transition [:proposed, :changed_by_worker, :changed_by_manager] => :rejected
    end

    event :change_by_worker do
      transition [:proposed, :changed_by_manager] => :changed_by_worker
    end

    event :change_by_manager do
      transition :changed_by_worker => :changed_by_manager
    end

    event :cancel do
      transition all - [:canceled] => :canceled
    end
  end

  def acceptable_pace?(pace)
    return true if self.started_at > pace.ago

    duration = (self.ended_at - self.started_at).to_i
    past_duration = (DateTime.now - pace.ago.to_date).to_i
    min_duration = self.limit_min.hour / duration * past_duration

    duration = worker_timings_by_project
      .select{ |field| field[:at] > pace.ago}
      .map(&:duration)
      .sum

    duration >= min_duration
  end

  def worker_timings_by_project
    client = Toggl::Base.new(self.worker.toggl_api_key, self.worker.id)
    entries = []
    response = client.me(true)
    response.time_entries
      .presence
      .select{ |field| field[:pid] == self.project_id }
      .each do |field|
        entries << field if field['duration'] > 0
      end
    entries
  end

  def can_be_accepted_by_user?(user)
    if user == worker && user == manager
      can_accept?
    elsif user == worker
      proposed? || changed_by_manager?
    elsif user == manager
      changed_by_worker?
    end
  end

  def can_be_rejected_by_user?(user)
    if user == worker && user == manager
      can_reject?
      elsif user == worker
        proposed? || changed_by_manager?
    elsif user == manager
      changed_by_worker?
      end
    end

  def can_be_canceled_by_user?(user)
    user == manager && can_cancel?
  end

  def can_be_changed_by_user?(user)
    if user == worker && user == manager
      can_change_by_manager? || can_change_by_worker?
    elsif user == worker
      can_change_by_worker?
    elsif user == manager
      can_change_by_manager?
    end
  end

  def notify_users(transition)
    [manager, worker].uniq.compact.each do |user|
      NotificationMailer.agreement_state_changed(self, user.email, transition.from, transition.to).deliver
    end
  end
end
