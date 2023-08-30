# frozen_string_literal: true

Rails.application.routes.draw do
  root 'site#index'

  namespace :market_data, only: %i[index show] do
    resources :currencies, id: /[[:upper:]]{6}|[[:digit:]]+/
    resources :equities
    resources :options
  end

  resources :equities

  resources :asset_pairs do
    resources :exchange_rates, shallow: true
    resources :options, shallow: true do
      post 'compute', on: :member
    end
  end
  get 'options', to: 'options#index'

  # The Country and Currency models return the 3-letter alphabetic code instead
  # of their internal ID (except for historic currencies) in their #to_param
  # methods. We restrict the routing :id parameter to values that could be
  # internal ID, numeric code or alphabetic code.
  # We also restrict to the actions #index and #show.
  resources :currencies, id: /[[:upper:]]{3}|[[:digit:]]+/, only: %i[index show]
  resources :countries, id: /[[:upper:]]{2,3}|[[:digit:]]+/,
                        only: %i[index show] do
    resources :exchanges, id: /.*/, shallow: true
  end
  get '/exchanges', to: 'exchanges#index'

  # Redirect alphabetic codes that aren't written in, but required to be,
  # entirely uppercase to the uppercase equivalent.
  # Each line in the following Hash is of the format
  # +controller: id_constraints+
  {
    countries: /[[:alpha:]]{2,3}/,
    currencies: /[[:alpha:]]{3}/
  }.each do |controller, id|
    get "/#{controller}/:id",
        id:, to: redirect { |p| "/#{controller}/#{p[:id].upcase}" }
  end
end
