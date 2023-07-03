# frozen_string_literal: true

json.extract! option, :id, :underlying_id, :expires_at, :type, :style, :strike,
              :created_at, :updated_at
json.url option_url(option, format: :json)
