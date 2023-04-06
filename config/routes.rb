Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "products#index"

  get "/orders/new/:product_id" => "orders#new", as: 'orders_new'

  resources :customers
  resources :products do
    collection do
      get "active"
      get "filter"
    end
  end
  resources :orders
end
