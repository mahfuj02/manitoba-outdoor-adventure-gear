Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Address management
  resources :addresses do
    member do
      patch :set_default
    end
  end

  get "carts/show"
  get "carts/add_item"
  get "carts/update_item"
  get "carts/remove_item"
  get "products/index"
  get "products/show"
  get "contact/index"
  get "about/index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  get 'about', to: 'about#index'
  get 'contact', to: 'contact#index'

  # Cart routes
  get 'cart', to: 'carts#show', as: 'cart'
  post 'cart/add/:product_id', to: 'carts#add_item', as: 'add_to_cart'
  patch 'cart/update/:id', to: 'carts#update_item', as: 'update_cart_item'
  delete 'cart/remove/:id', to: 'carts#remove_item', as: 'remove_cart_item'
  
  # Order routes
  resources :orders, only: [:index, :show]
  
  # Checkout process
  get 'checkout', to: 'checkout#index'
  post 'checkout/address', to: 'checkout#create_address'
  get 'checkout/review', to: 'checkout#review'
  post 'checkout/complete', to: 'checkout#complete'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root 'home#index'
  # root 'products#index'
end