class ManagerNotifierJob

  @queue = :simple

  def self.perform
    Rails.cache.fetch ['manager_notifier_job', Date.current] do
      ending_period = 2.days
      User.with_ending_agreements_for(ending_period).each do |user|
        agreements = user.managing_agreements.ending_for(ending_period)
        NotificationMailer.ending_agreements(
          user.email, agreements, ending_period).deliver
      end

      Rails.logger.info(
        "Send mails 'ending_agreements' for managers: complete at #{Time.now}")
      ''
    end
  end
end
