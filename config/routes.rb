Rails.application.routes.draw do
  resources :equities
  resources :exchange_rates
  resources :exchanges
  resources :asset_pairs

  # Countries and currencies should be indexed by their 3-letter alphabetic
  # codes instead of internal IDs. Plus, since they are pretty static and there
  # shouldn't be much editing required, they are restricted to #index and #show.
  scope abc: /[[:upper:]]{3}/, only: %i[index show] do
    resources :countries, param: :abc
    resources :currencies, param: :abc
  end

  # Redirect country and currency alphabetic codes that aren't written in
  # entirely uppercase to the uppercase equivalent.
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
