class APIController < ActionController::Base
  before_filter :set_format
  before_action :authenticate

  def get_profile_info

  end

  def user_auth_token
    validator = GoogleIDToken::Validator.new
    jwt = validator.check(params['id_token'], params['audience'])
    if jwt
      email = jwt['email']
      user = User.find_by!(email)
      render :json => {token: "fake_token"}
    else
      render :json => {error: "Invalid authentication"}
    end
  end

  private
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      token == ENV['API_TOKEN']
    end
  end

  def set_format
    request.format = 'json'
  end

end