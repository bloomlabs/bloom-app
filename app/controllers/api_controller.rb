class APIController < ActionController::Base
  before_filter :set_format
  before_action :authenticate

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