class ApplicationController < ActionController::Base
  # Ensure appropriate permissions exist for user
  # check_authorization unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Track users who made changes to models
  before_filter :set_paper_trail_whodunnit

  # Handle access denied
  rescue_from CanCan::AccessDenied do |exception|
    if not current_user.nil? and current_user.manager?
      redirect_to rails_admin.dashboard_path, flash: {error: 'Your account doesn\'t have sufficient permissions to do that, please contact Ash if you think this is an error.'}
    else
      redirect_to main_app.root_path, flash: {error: "Whoops, the app doesn't think you're allowed to do that.<br>If you think this is a mistake, please <a href='mailto:#{Rails.configuration.x.help_contact.email}'>email #{Rails.configuration.x.help_contact.name}</a>."}
    end
  end

  def oauth_apply_callback_generator
    if not params[:plan] or (params[:plan] != 'community' and params[:plan] != 'coworking' and params[:plan] != 'dedicated' and params[:plan] != 'freelance')
      head 404 and return
    end
    redirect_to user_omniauth_authorize_path(:google_oauth2,
                                             redirect_uri: user_omniauth_callback_url(action: 'google_oauth2'),
                                             state: "{\"start_application\":\"#{params[:plan]}\"}")
  end

  # Devise 
  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  # Redirect back to same location if user is caught by authenticate_user!
  def after_sign_in_path_for(resource)
    session["user_return_to"] || dashboard_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation) }
  end
end
