Rails.application.routes.draw do
  
  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :orders
  # resources :order_items
  resources :schools

  #Additional Routes for Users

  get 'user_all_orders/:id' => 'users#user_all_orders', :as => :user_all_orders

  # Routes for order items
  patch'mark_as_shipped/:id' => 'order_items#mark_as_shipped', :as => :mark_as_shipped

  # Routes for orders
  get 'payment_confirm/:id' => 'orders#payment_confirm', :as => :payment_confirm
  
  # Additional Routes for Items

  get 'boards' => 'items#index_boards', :as => :index_boards
  get 'clocks' => 'items#index_clocks', :as => :index_clocks
  get 'pieces' => 'items#index_pieces', :as => :index_pieces
  get 'supplies' => 'items#index_supplies', :as => :index_supplies

  
  #Routes for login and sessions
  resources :users
  resources :sessions
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  #Cart routes
  get 'add_to_cart' => 'orders#add_to_cart', as: :add_to_cart 
  get 'remove_from_cart' => 'orders#remove_from_cart', as: :remove_from_cart
  get 'cart' => 'orders#cart', as: :cart

  #Additional Routes for Orders

  get 'checkout' => 'orders#new', as: :checkout

  #Reorder List
  get 'reorder_list' => 'items#reorder_list', as: :reorder_list
  
  # Set the root url
  root :to => 'home#home'  

end
