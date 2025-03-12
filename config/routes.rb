Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount SnfCore::Engine => "/", as: "snf_core"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
  resources :businesses
  resources :business_documents
  resources :users
  resources :groups
  resources :stores
  resources :products do
    collection do
      post :wholesalers
    end
  end
  resources :categories
  resources :addresses
  resources :customer_groups
  resources :store
  resources :store_inventories
  resources :wallets
  resources :delivery_orders
  resources :orders do
    collection do
      get :my_orders
    end
  end
  resources :order_items
  resources :virtual_accounts
  resources :item_requests
  resources :virtual_account_transactions do
    collection do
      post :pay
    end
  end
  resources :quotations

end
