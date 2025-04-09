Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

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


# config/routes.rb (cart routes)
  get 'cart', to: 'carts#show', as: 'cart'
  post 'cart/add/:product_id', to: 'carts#add_item', as: 'add_to_cart'
# or if you're using 'id' in the URL:
# post 'cart/add/:id', to: 'carts#add_item', as: 'add_to_cart'
  patch 'cart/update/:id', to: 'carts#update_item', as: 'update_cart_item'
  delete 'cart/remove/:id', to: 'carts#remove_item', as: 'remove_cart_item'
  root 'products#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
