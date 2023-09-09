# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Option.
class MarketData::OptionsController < AssetPairsController
  private

  def set_asset_pair
    super
  rescue ActionController::RoutingError
    base_asset = find_option(params[:id])

    @asset_pair = asset_pairs.find_by!(base_asset:) if base_asset.present?
  ensure
    @underlying = @asset_pair&.base_asset&.underlying
  end
end
