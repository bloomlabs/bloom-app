Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  post 'membership_payments/stripe_webhook'
  authenticate :user do
    get 'dashboard/dashboard'

    post 'membership_payments/capture_single'
    post 'membership_payments/capture_subscription'
    post 'membership_payments/process_cancel_subscription'
    get 'membership_payments/payment_confirmation'
    get 'membership_payments/pay_single'
    get 'membership_payments/cancel_subscription'
  end

  resources :membership_types

  resources :membership_requests do
    member do
      MembershipRequest.workflow_spec.states.keys.each do |state|
        get "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_#{state}"
        post "stage/#{state}" => "membership_requests#workflow_#{state}", as: "workflow_submit_#{state}"
      end
    end
  end


  resources :users do 
    member do
      get :dashboard
    end
  end

  namespace :admin do
    resources :membership_requests, only: [:index, :show, :update]
    post 'membership_requests/reset_community_members'
  end

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
