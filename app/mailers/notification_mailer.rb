class NotificationMailer < ActionMailer::Base

  def new_agreement_email(agreement, user)
    @agreement = agreement
    @url = url_for(@agreement)
    mail(to: user.email, subject: 'Toggrep notification')
  end

end