# frozen_string_literal: true

json.extract! currency, :id, currency, :alphabetic_code, :numeric_code,
              :minor_unit, :active, :created_at, :updated_at
json.url currency_url(currency, format: :json)
