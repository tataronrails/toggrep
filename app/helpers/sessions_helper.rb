module SessionsHelper

  def incorrect_toggl_api_key?
    params[:incorrect_api_key].present?
  end

end
