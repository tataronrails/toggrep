require 'toggl_api/error'

module Toggl
  module Request

    private

    def request(method, path, params = {})
      start_time = Time.now
      response = connection.send(method.to_sym, basic_path(path), params)
      end_time = Time.now
      opt = {
        method: method,
        path: path,
        start_time: start_time,
        end_time: end_time,
        params: params,
        response: response,
        toggrep_user_id: @toggrep_user_id
      }
      Toggl::Logger.execute(false, opt)
      handle_response(response)
    rescue Faraday::Error::ClientError
      Toggl::Logger.execute(true)
      raise TogglApi::Error
    end

  end

  class Base

    def initialize(username, toggrep_user_id, pass = 'api_token')
      @username, @pass = username, pass
      @toggrep_user_id = toggrep_user_id
    end

  end
end
