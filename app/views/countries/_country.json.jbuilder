json.extract! country, :id, :name, :alpha2_code, :alpha3_code, :numeric_code, :created_at, :updated_at
json.url country_url(country, format: :json)
