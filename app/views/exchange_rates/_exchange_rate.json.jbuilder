# frozen_string_literal: true

json.extract! exchange_rate, :id, :asset_pair_id, :base_rate, :counter_rate,
              :observed_at, :created_at, :updated_at
json.url exchange_rate_url(exchange_rate, format: :json)
