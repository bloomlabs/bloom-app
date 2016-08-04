class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user, newly_created = User.from_omniauth(request.env['omniauth.auth'])

    if params[:state]
        begin
          state_json = ActiveSupport::JSON.decode(params[:state])
          if state_json['start_application']
            plan = state_json['start_application']
            stripe_id = 'full-time'
            if plan == 'coworking'
              stripe_id = 'part-time'
            end
            req = MembershipRequest.find_by(user: @user, closed: false, membership_type: MembershipType.find_by_stripe_id(stripe_id))
            if not req
              authorize! :new, @user
              req = MembershipRequest.new(user: @user, membership_type: MembershipType.find_by_stripe_id(stripe_id))
              req.save!
            end
            session['user_return_to'] = membership_request_path(req)
          end
        rescue ActiveSupport::JSON.parse_error
        end
    end

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'Google'
      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end