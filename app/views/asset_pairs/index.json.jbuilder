# frozen_string_literal: true

json.array! @asset_pairs, partial: 'asset_pairs/asset_pair', as: :asset_pair
