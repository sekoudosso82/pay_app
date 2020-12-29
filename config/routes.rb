Rails.application.routes.draw do
  resources :payments
  resources :shoppingcart_items
  resources :shoppingcarts
  resources :items
  resources :users
  get '/paypal_payments', to: 'payments#paypal_payments' 
  get '/card_payments', to: 'payments#card_payments' 

  get '/all_transactions', to: 'checkouts#all_transactions'
  get '/paypal_transactions', to: 'checkouts#paypal_transactions'
  get '/card_transactions', to: 'checkouts#card_transactions'
  get '/refunded_transactions', to: 'checkouts#refunded_transactions'
  
  get '/refund_transaction', to: 'checkouts#refund_transaction' 
  get '/vault_credit_card', to: 'checkouts#vault_credit_card'
  #root
  # root to: 'items#index'
  root to: 'sessions#new'

  # login routes 
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'

  # sign up routes 
  get '/signup', to: 'users#new', as: 'signup'

  #logout routes
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # add to shoppingcart_item 
  post '/add_to_cart/:id' => 'shoppingcart_items#add_to_cart', :as => 'add_to_cart'

  # checkout 
  # post 'checkout', to: 'items#checkout'
  # post 'checkout', to: 'items#checkout'
  resources :checkouts,  only: [:new, :create, :show]
end