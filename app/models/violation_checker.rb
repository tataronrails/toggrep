class ViolationChecker

  def process!
    count = 0
    Agreement.active.each do |agreement|
      ViolationRule.all.each do |violation_rule|
        if agreement.worker.should_be_checked?(violation_rule, agreement)
          Resque.enqueue(ViolationCheckJob, violation_rule.id, agreement.id)
          count += 1
        end
      end
    end
    Rails.logger.info("ViolationChecker: enqueued #{count} jobs")
  end

  private

  def self.check(violation_rule, user)
    # user is inside the variable condition
    begin
      instance_eval(violation_rule.condition)
    rescue StandardError
      Rails.logger.error("[error] ViolationChecker: ViolationRule(#{violation_rule.id}), User(#{user.id}) at #{Time.now}")
      false
    end
  end

end
