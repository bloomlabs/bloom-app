# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def create
    if sign_up_params[:email].ends_with? '@bloom.org.au'
      redirect_to root_path, notice: 'Bloom staff aren\'t permitted to sign up manually. Please login using Google.'
    else
      super
    end
  end
end