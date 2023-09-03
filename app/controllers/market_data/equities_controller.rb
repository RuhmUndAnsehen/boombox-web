# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Equity.
class MarketData::EquitiesController < AssetPairsController
  class << self
    def find_base_asset(id) = ::EquitiesController.find_equity(id)
  end
end
