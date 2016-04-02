class WifiController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
  end

  def update
    @user.wifi_password = params[:wifi_password]

    if @user.save
      redirect_to wifi_path, notice: 'Wifi password set! Please give up to 10 minutes for it to update.'
    else
      render :show
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end
end
