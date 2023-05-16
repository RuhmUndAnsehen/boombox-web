Rails.application.routes.draw do
  scope only: %i[index show] do
    resources :countries, param: :alpha3_code
    resources :currencies, param: :alphabetic_code
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
