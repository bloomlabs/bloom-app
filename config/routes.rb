Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}


  resources :user_profiles, only: [:new, :create]

  scope 'membership_payments', controller: :membership_payments do
    post 'stripe_webhook'
    post 'capture_single'
    post 'capture_subscription'
    post 'process_cancel_subscription'
    get 'payment_confirmation'
    get 'pay_single'
    get 'cancel_subscription'
  end

  resources :membership_requests do
    member do
      MembershipRequest.workflow_spec.states.keys.each do |state|
        get "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_#{state}"
        post "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_submit_#{state}"
      end
    end
  end


  # get 'admin/dashboard' => 'admin#dashboard'
  # namespace :admin do
  #   resources :membership_requests, only: [:index, :show, :update]
  #   post 'reset_community_members' => 'membership_requests#reset_community_members'
  #
  #   resources :membership_types
  # end


  get 'dashboard' => 'welcome#dashboard'
  root 'welcome#index'
end
