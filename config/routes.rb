Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}

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

  get '/admin/membership_requests/:id', to: redirect('/admin/membership_request/%{id}') # Backwards compatibility
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'dashboard' => 'welcome#dashboard'
  root 'welcome#index'
end
