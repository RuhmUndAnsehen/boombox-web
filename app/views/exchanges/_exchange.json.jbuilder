# frozen_string_literal: true

json.extract! exchange, :id, :country_id, :symbol, :name, :created_at,
              :updated_at
json.url exchange_url(exchange, format: :json)
