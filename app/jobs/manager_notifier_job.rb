class ManagerNotifierJob

  @queue = :simple

  def self.perform
    ending_period = 2.days
    User.with_ending_agreements_for(ending_period).each do |user|
      agreements = user.managing_agreements.ending_for(ending_period)
      if agreements.size > 0
        NotificationMailer.ending_agreements(user.email, agreements).deliver
      end
    end

    Rails.logger.info(
      "Send mails 'ending_agreements' for managers: complete at #{Time.now}")
  end
end
