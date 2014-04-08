class ViolationCheck < ActiveRecord::Base

  belongs_to :violation_rule
  belongs_to :agreement

  after_create :send_notification_mail, if: :result

  validates :result, presence: true

  scope :success, -> {
    where(result: true)
  }

  private

  def send_notification_mail
    NotificationMailer.new_violation(self.id).deliver
  end
end
