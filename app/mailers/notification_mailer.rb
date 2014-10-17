class NotificationMailer < ActionMailer::Base
  # include Resque::Mailer

  default from: Toggrep::EMAIL['default_from']

  def new_violation(violation_check_id)
    @violation_check = ViolationCheck.find(violation_check_id)
    @violation_rule = @violation_check.violation_rule
    @agreement = @violation_check.agreement
    @worker = @agreement.worker
    manager = @agreement.manager
    mail(to: manager.email, subject: 'Toggrep notification')
  end

  def new_agreement(agreement_id)
    @agreement = Agreement.find(agreement_id)
    @url = url_for(@agreement)
    mail(to: @agreement.worker.email, subject: 'Toggrep notification')
  end

  def agreement_state_changed(agreement, email, from_status, to_status)
    @agreement = agreement
    @from = from_status
    @to = to_status
    mail(to: email, subject: 'Toggrep notification')
  end

  def ending_agreements(email, agreements, ending_period)
    @ending_days = ending_period / 1.day
    @ending_date = Date.current - ending_period
    @agreements = agreements
    mail(to: email, subject: 'Toggrep notification')
  end
end
