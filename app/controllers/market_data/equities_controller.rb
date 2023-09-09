# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Equity.
class MarketData::EquitiesController < AssetPairsController
  include ::EquitiesController::Finders

  private

  def set_asset_pair
    super
  rescue ActionController::RoutingError
    base_asset = find_equity_or_redirect(params[:id])

    # #find_equity_or_redirect only returns nil when a redirect was initiated,
    # hence skip querying the DB in this case.
    @asset_pair = asset_pairs.find_by!(base_asset:) if base_asset.present?
  end
end
