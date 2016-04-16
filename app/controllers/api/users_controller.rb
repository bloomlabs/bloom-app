class Api::UsersController < ApiController
  def index
    @users = User.all
  end
end
