# frozen_string_literal: true

Rails.application.routes.draw do
  resources :equities
  resources :exchange_rates
  resources :exchanges
  resources :asset_pairs

  # The Country and Currency models return the 3-letter alphabetic code instead
  # of their internal ID (except for historic currencies) in their #to_param
  # methods. We restrict the routing :id parameter to values that could be
  # internal ID, numeric code or alphabetic code.
  # We also restrict to the actions #index and #show.
  scope only: %i[index show] do
    resources :countries, id: /[[:upper:]]{2,3}|[[:digit:]]+{/
    resources :currencies, id: /[[:upper:]]{3}|[[:digit:]]+/
  end

  # Redirect country and currency alphabetic codes that aren't written in
  # entirely uppercase to the uppercase equivalent.
  # TODO: Determine if the redirect can be done in a way that feels less hacky.
  scope to: redirect { |p, r|
              "#{r.fullpath.match(%r{\A/[^/]*})}/#{p[:id].upcase}"
            } do
    get '/countries/:id', id: /[[:alpha:]]{2,3}/
    get '/currencies/:id', id: /[[:alpha:]]{3}/
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
