class WelcomeController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!, except: [:index]

  def index
    if current_user
      redirect_to dashboard_path
    end
  end

  def dashboard
    @current_request = current_user.latest_request
    @active_applications = current_user.membership_requests.where.not(closed: true)
  end
end
