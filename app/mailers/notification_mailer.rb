class NotificationMailer < ActionMailer::Base
  include Resque::Mailer

  default from: Toggrep::EMAIL['default_from']

  def no_toggl_timers(violation_check_id)
    @violation_check = ViolationCheck.find(violation_check_id)
    @violation_rule = @violation_check.violation_rule
    @agreement = @violation_check.agreement
    @worker = @agreement.worker
    manager = @agreement.manager
    mail to: manager.email, subject: 'Toggrep notification'
  end

  def new_agreement_email(agreement, user)
    @agreement = agreement
    @url = url_for(@agreement)
    mail(to: user.email, subject: 'Toggrep notification')
  end
end
