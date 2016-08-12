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
        Heap.add_user_properties current_user.id,
                                 full_name: current_user.firstname + ' ' + current_user.lastname,
                                 email: current_user.email,
                                 date_of_birth: @user_profile.date_of_birth.to_s,
                                 education_status: @user_profile.education_status || '',
                                 gender: @user_profile.gender || '',
                                 nationality: @user_profile.nationality || '',
                                 signup_reason: @user_profile.signup_reason || '',
                                 university: @user_profile.university || '',
                                 university_degree: @user_profile.university_degree || '',
                                 university_student_number: @user_profile.university_student_number || '',
                                 telephone_number: @user_profile.telephone_number || ''
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
    params.require(:user_profile).permit(:signup_reason, :date_of_birth, :gender, :student_type, :education_status, :university_degree, :university_student_number, :nationality, :telephone_number, :university, :user_id_id)
  end
end
