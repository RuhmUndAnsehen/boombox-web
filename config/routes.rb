Rails.application.routes.draw do
  scope only: %i[index show] do
    resources :countries, param: :abc
    resources :currencies, param: :abc
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
