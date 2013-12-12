class ViolationCheckerJob

  @queue = :simple

  def self.perform
    checker = ViolationChecker.new
    checker.process!
    Rails.logger.info "ViolationChecker: complete at #{Time.now}"
  end

end
