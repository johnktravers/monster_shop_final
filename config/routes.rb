Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'items#index'

  resources :merchants, only: [:index, :show] do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post   '/cart/:item_id',                      to: 'cart#add_item'
  get    '/cart',                               to: 'cart#show'
  delete '/cart',                               to: 'cart#empty'
  delete '/cart/:item_id',                      to: 'cart#remove_item'
  patch  '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'
  patch  '/cart/:coupon_id',                    to: 'cart#apply_coupon'

  get   '/register',           to: 'users#new'
  post  '/users',              to: 'users#create'
  get   '/profile',            to: 'users#show'
  get   '/profile/edit',       to: 'users#edit'
  patch '/profile',            to: 'users#update'

  get   '/profile/orders',     to: 'user_orders#index'
  get   '/profile/orders/new', to: 'user_orders#new'
  post  '/profile/orders',     to: 'user_orders#create'
  get   '/profile/orders/:id', to: 'user_orders#show'
  patch '/profile/orders/:id', to: 'user_orders#update'

  get    '/profile/addresses/new',      to: 'user_addresses#new'
  post   '/profile/addresses',          to: 'user_addresses#create'
  get    '/profile/addresses/:id/edit', to: 'user_addresses#edit'
  patch  '/profile/addresses/:id',      to: 'user_addresses#update'
  delete '/profile/addresses/:id',      to: 'user_addresses#destroy'

  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

  namespace :merchant do
    resources :items, except: [:show]

    root  'dashboard#index'
    get   '/orders/:id',                                  to: 'orders#show'
    patch '/orders/:order_id/item_orders/:item_order_id', to: 'orders#update'

    get    '/coupons',          to: 'coupons#index'
    get    '/coupons/new',      to: 'coupons#new'
    post   '/coupons',          to: 'coupons#create'
    get    '/coupons/:id/edit', to: 'coupons#edit'
    patch  '/coupons/:id',      to: 'coupons#update'
    delete '/coupons/:id',      to: 'coupons#destroy'
  end

  namespace :admin do
    resources :users, only: [:index, :show]

    root 'dashboard#index'

    get   '/users/:id/orders',                to: 'user_orders#index'
    get   '/users/:user_id/orders/:order_id', to: 'user_orders#show'
    patch '/users/:user_id/orders/:order_id', to: 'user_orders#update'

    get    '/merchants/new',      to: 'merchants#new'
    post   '/merchants',          to: 'merchants#create'
    get    '/merchants/:id',      to: 'dashboard#merchant_index'
    get    '/merchants/:id/edit', to: 'merchants#edit'
    patch  '/merchants/:id',      to: 'merchants#update'
    delete '/merchants/:id',      to: 'merchants#destroy'

    get   '/merchants/:merchant_id/orders/:order_id',                            to: 'merchant_orders#show'
    patch '/merchants/:merchant_id/orders/:order_id/item_orders/:item_order_id', to: 'merchant_orders#update'
  end
end
