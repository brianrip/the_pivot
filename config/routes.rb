Rails.application.routes.draw do
  root to: "categories#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: [:new, :create, :update, :edit]
  get "/dashboard", to: "users#show"

  namespace :users do
    resources :photos, only: [:index], path: ':id/photos'
  end

  namespace :admin do
    get ":studio/dashboard", to: "users#show"
    resources :orders, only: [:index, :update, :show], path: '/:studio/orders'
    resources :users, only: [:index], path: '/:studio/users'
    patch "/status", to: "users#change_admin_status"
    resources :photos, except: [:destroy], path: '/:studio/photos'
    patch "/:studio/status/:id", to: "photos#change_status", as: :change_photo_status
  end

  namespace :platform_admin do
    get "/dashboard", to: "studios#index"
    resources :studios, only: [:update]
    resources :orders, only: [:index, :show]
  end

  resources :cart_photos, only: [:create]
  get "/cart", to: "cart_photos#show"
  delete "/cart", to: "cart_photos#destroy"
  patch "/cart", to: "cart_photos#update"

  resources :orders, only: [:index, :show, :create, :new]

  resources :photos, only: [:index, :show, :create]

  resources :studios, except: [:show]
  resources :categories, only: [:index, :show]

  get '/:id', to: "studios#show", as: :studio_show
end
