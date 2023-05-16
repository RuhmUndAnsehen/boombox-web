Rails.application.routes.draw do
  resources :countries, param: :alpha3_code
  resources :currencies, param: :alphabetic_code
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
