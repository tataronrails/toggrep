class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  def skip_authorization_check?
    devise_controller? or
    pages_controller? or
    rails_admin_controller?
  end

  private

  def pages_controller?
    self.class.ancestors.include? HighVoltage::PagesController
  end

end
