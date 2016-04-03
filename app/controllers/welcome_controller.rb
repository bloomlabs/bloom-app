class WelcomeController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!, except: [:index]

  def index
    if current_user
      redirect_to dashboard_path
    end
  end

  def dashboard
    @active_memberships = current_user.active_memberships
    @active_applications = current_user.membership_requests.where.not(closed: true)
  end
end
