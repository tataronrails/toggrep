class ViolationCheckJob

  @queue = :simple

  def self.perform(violation_rule_id, agreement_id)
    violation_rule = ViolationRule.find(violation_rule_id)
    agreement = Agreement.find(agreement_id)
    result = ViolationChecker.check(violation_rule, agreement.worker)
    ViolationCheck.create(violation_rule: violation_rule, agreement: agreement, result: result)
    Rails.logger.info "ViolationCheckJob: complete at #{Time.now}"
  end

end
