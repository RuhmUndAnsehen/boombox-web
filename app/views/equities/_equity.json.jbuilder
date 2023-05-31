# frozen_string_literal: true

json.extract! equity, :id, :symbol, :name, :created_at, :updated_at
json.url equity_url(equity, format: :json)
