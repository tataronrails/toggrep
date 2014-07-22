module Toggl
  class Logger

    def self.execute(error = false, options = {})
      log_file ||= File.open(Rails.root.join('log/toggl.log'), 'a')
      log_file.sync = true
      logger = ::Logger.new(log_file)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
      if error
        logger.error("\n\n Exception Faraday::Error::ClientError")
        return
      end

      message = <<-MSG
        Started #{options[:method].upcase} \"#{Toggl::Request::ENDPOINT}#{options[:path]}\"
          User Id: #{options[:toggrep_user_id]}
          Parameters: #{options[:params]}
          Request sent at: #{options[:start_time]}
          Response received at: #{options[:end_time]}
          Response data size: #{options[:response].headers['Content-Length']}
        Completed with #{options[:response].status} in #{(options[:end_time]-options[:start_time]).round(1)}ms
      MSG
      message.gsub!(/^\s{8}/, '')
      logger.info(message)
    end

  end
end
