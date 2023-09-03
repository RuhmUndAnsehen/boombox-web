# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Equity.
class MarketData::EquitiesController < AssetPairsController
  class << self
    def find_asset_pair(id)
      return super if int?(id)

      base_asset = ::EquitiesController.find_equity(id)
      asset_pairs.where(base_asset:).first!
    end
  end
end
