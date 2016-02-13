class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Devise 
  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def after_sign_in_path_for(resource)
    return dashboard_user_path(current_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation) }
  end
end
