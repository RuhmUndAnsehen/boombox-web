Rails.application.routes.draw do
  scope abc: /[[:upper:]]{3}/, only: %i[index show] do
    resources :countries, param: :abc
    resources :currencies, param: :abc
  end

  # Redirect country and currency alphabetic codes that aren't written in
  # entirely lowercase to the uppercase equivalent.
  # TODO: Determine if the redirect can be done in a way that feels less hacky.
  scope abc: /[[:alpha:]]{3}/,
        to: redirect { |p, r| "#{r.fullpath.match(/\A\/[^\/]*/)}/#{p[:abc].upcase}" } do
    get '/countries/:abc'
    get '/currencies/:abc'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
