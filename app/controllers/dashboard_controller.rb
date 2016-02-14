class DashboardController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!

  def dashboard
  end
end
