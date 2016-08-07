Rails.application.routes.draw do
  get '/oauth_apply' => 'application#oauth_apply_callback_generator'

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :user_profiles, only: [:new, :create]
  resource :wifi, only: [:show, :update], controller: 'wifi'

  scope 'membership_payments', controller: :membership_payments do
    post 'stripe_webhook'
    post 'capture_single'
    post 'capture_subscription'
    post 'process_cancel_subscription'
    get 'payment_confirmation'
    get 'pay_single'
    get 'cancel_subscription'
  end

  resources :membership_requests, only: [:new, :show, :create] do
    member do
      MembershipRequest.workflow_spec.states.keys.each do |state|
        get "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_#{state}"
        post "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_submit_#{state}"
      end
    end
  end

  namespace :api do
    resources :users, only: [:index]
  end

  get 'booking/:name/new' => 'booking#new'
  post 'booking/:name/pay' => 'booking#pay'
  get 'booking/:id/confirmation' => 'booking#confirmation'

  scope 'api', controller: :api do
    post 'user_auth_token'
    post 'profiles/:id' => 'api#get_profile_info'
    post 'profiles/:id/update' => 'api#update_profile_info'
    get 'profiles/:id/profile_image_upload_url' => 'api#profile_image_upload_url'
  end

  get '/admin/membership_requests/:id', to: redirect('/admin/membership_request/%{id}') # Backwards compatibility
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'dashboard' => 'welcome#dashboard'
  root 'welcome#index'
end
