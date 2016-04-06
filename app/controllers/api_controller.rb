class APIController < ActionController::Base
  before_filter :set_format
  before_action :authenticate
  before_action :authenticate_user_token, only: [:get_profile_info]

  def get_profile_info
    user = User.find_by(id: params["id"])
    if user.nil?
      render :json => {error: "Invalid user id"}
    else
      profile = UserProfile.find_by_user_id(user.id)
      render :json => {
        firstname: user.firstname,
        lastname: user.lastname,
        profile: {
            description: profile.user_description,
            startup_name: profile.primary_startup_name,
            startup_description: profile.primary_startup_description
        }
      }
    end
  end

  def user_auth_token
    validator = GoogleIDToken::Validator.new
    jwt = validator.check(params['id_token'], params['audience'])
    if jwt
      email = jwt['email']
      user = User.find_by!(email)
      if !user.token
        user.regenerate_token
        user.save
      end
      render :json => {token: user.token, id: user.id}
    else
      render :json => {error: "Invalid authentication"}
    end
  end

  private
  def authenticate_user_token
    User.find_by!(token: params["token"])
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