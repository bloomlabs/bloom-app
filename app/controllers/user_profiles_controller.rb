class UserProfilesController < ApplicationController
  load_and_authorize_resource

  # GET /user_profiles/new
  def new
    @user_profile = UserProfile.new
  end

  # POST /user_profiles
  # POST /user_profiles.json
  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.user = current_user

    respond_to do |format|
      if @user_profile.save
        redirect_path = session.delete(:user_profile_return_to) || dashboard_path
        format.html { redirect_to redirect_path, notice: 'Thanks for telling us about yourself!' }
        format.json { render :show, status: :created, location: @user_profile }
      else
        format.html { render :new }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_profile
    @user_profile = UserProfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_profile_params
    params.require(:user_profile).permit(:signup_reason, :date_of_birth, :gender, :student_type, :education_status, :current_degree, :user_id_id)
  end
end
