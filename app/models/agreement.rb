class Agreement < ActiveRecord::Base

  STATES = %w(
    proposed
    changed_by_worker
    changed_by_manager
    rejected
    accepted
    canceled
  )

  belongs_to :manager, class_name: User
  belongs_to :worker, class_name: User
  has_many :violation_checks

  validates :limit_min, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :limit_max, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :started_at, presence: true
  validates :ended_at, presence: true

  scope :active, -> {
    where('? between started_at and ended_at', Date.today)
  }
  scope :user_agreements, -> (user) {
    where('manager_id OR worker_id = ?', user)
  }

  state_machine :state, :initial => :proposed do

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

end
