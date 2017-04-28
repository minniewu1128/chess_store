Rails.application.routes.draw do
  
  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :orders
  resources :order_items
  resources :schools
  
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
  get 'add_to_cart/:item_id' => 'orders#add_to_cart', as: :add_to_cart 
  get 'remove_from_cart/:item_id' => 'orders#remove_from_cart', as: :remove_from_cart

  #Reorder List
  get 'reorder_list' => 'items#reorder_list', as: :reorder_list
  
  # Set the root url
  root :to => 'home#home'  

end
