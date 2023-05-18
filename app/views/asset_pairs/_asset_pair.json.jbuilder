json.extract! asset_pair, :id, :base_asset_id, :base_asset_type, :counter_asset_id, :counter_asset_type, :base_rate, :counter_rate, :observed_at, :created_at, :updated_at
json.url asset_pair_url(asset_pair, format: :json)
