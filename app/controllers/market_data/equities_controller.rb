# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Equity.
class MarketData::EquitiesController < AssetPairsController
  include ::EquitiesController::Finders

  singleton_class
    .__send__(:alias_method, :find_base_asset, :find_equity)
end
