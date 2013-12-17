class ViolationCheck < ActiveRecord::Base

  belongs_to :violation_rule
  belongs_to :agreement

  after_create :check_to_send_mail, if: :result

  validates :result, presence: true

  private

  def check_to_send_mail
    NotificationMailer.no_toggl_timers(self.id).deliver
  end
end
