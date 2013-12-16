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
  # belongs_to :project

  #validates :state, presence: true, include: {in: STATES}
  #validates :limit_min, presence: true, numericality: { only_integer: true, greater_than: 0 }
  #validates :limit_max, numericality: { only_integer: true, greater_than: 0 }
  #validates :started_at, presence: true
  #validates :ended_at, presence: true

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
      transition all => :canceled
    end
  end

  def can_be_changed_by_user?(user)
    if accepted? || rejected? || canceled?
      false
    else
      if user == manager
        accepted? || changed_by_worker?
      elsif user == worker
        proposed? || changed_by_manager?
      end
    end
  end
end
