class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user
      redirect_to dashboard_user_path(current_user)
    end
  end
end
