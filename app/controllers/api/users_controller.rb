class Api::UsersController < APIController
  def index
    @users = User.all
  end
end
