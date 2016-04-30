class ApiController < ActionController::Base
  before_filter :set_format
  before_action :authenticate
  before_action :authenticate_user_token, only: [:get_profile_info]

  def update_profile_info
    user = User.find(params[:id])
    token_user = User.find_by!(token: params[:user_token])
    if !user.nil? and user.id == token_user.id
      profile = UserProfile.find_by_user_id(user.id)
      user.firstname = params[:firstname]
      user.lastname = params[:lastname]
      profile.user_description = params[:profile][:description]
      profile.primary_startup_name = params[:profile][:startup_name]
      profile.primary_startup_description = params[:profile][:startup_description]
      UserSkill.where(user_profile_id: profile.id).delete_all
      UserInterest.where(user_profile_id: profile.id).delete_all
      if !params[:profile][:skills].nil?
        params[:profile][:skills].each do |skill|
          UserSkill.create(skill: skill, user_profile_id: profile.id)
        end
      end  
      if !params[:profile][:interests].nil?
        params[:profile][:interests].each do |interest|
          UserInterest.create(interest: interest, user_profile_id: profile.id)
        end
      end
      user.save!
      profile.save!
      render :json => {
      }
    else 
      render :json => {
        error: "Unknown user"
      }
    end
  end

  def get_profile_info
    user = User.find(params[:id])
    if user.nil?
      render :json => {error: "Invalid/unknown user id"}
    else
      profile = UserProfile.find_by_user_id(user.id)
      if !profile.nil?
	      skills = UserSkill.where(user_profile_id: profile.id).select(:skill).map(&:skill)
	      interests = UserInterest.where(user_profile_id: profile.id).select(:interest).map(&:interest)
	  end
      render :json => {
        firstname: user.firstname || "",
        lastname: user.lastname || "",
        profile: {
            description: profile.user_description || "",
            startup_name: profile.primary_startup_name || "",
            startup_description: profile.primary_startup_description || "",
            interests: interests || [],
            skills: skills || []
        }
      }
    end
  end

  def user_auth_token
    validator = GoogleIDToken::Validator.new
    jwt = validator.check(params['id_token'], params['audience'])
    if jwt
      email = jwt['email']
      user = User.find_by_email!(email)
      if !user.token
        user.regenerate_token
        user.save
      end
      render :json => {token: user.token, id: user.id}
    else
      render :json => {error: "Invalid authentication", problem: validator.problem}
    end
  end

  private
  def authenticate_user_token
    User.find_by!(token: params[:user_token])
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      token == ENV['API_TOKEN']
    end
  end

  def set_format
    request.format = 'json'
  end
end