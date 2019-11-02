Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'items#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  post '/profile/orders', to: 'user_orders#create'

  get '/profile', to: 'users#show'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:id', to: 'user_orders#show'
  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  patch '/profile/orders/:id', to: 'user_orders#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  namespace :merchant do
    resources :items, except: [:show]

    root 'dashboard#index'
    
    get '/orders/:id', to: 'orders#show'
    patch '/orders/:order_id/item_orders/:item_order_id', to: 'orders#update'
  end

  namespace :admin do
    resources :users, only: [:index, :show]

    root 'dashboard#index'

    get '/users/:id/orders', to: 'user_orders#index'
    get '/users/:user_id/orders/:order_id', to: 'user_orders#show'
    patch '/users/:user_id/orders/:order_id', to: 'user_orders#update'

    get '/merchants/:id', to: 'dashboard#merchant_index'
    patch '/merchants/:id', to: 'merchants#update'
    get '/merchants/:merchant_id/orders/:order_id', to: 'merchant_orders#show'
    patch '/merchants/:merchant_id/orders/:order_id/item_orders/:item_order_id', to: 'merchant_orders#update'
  end
end
