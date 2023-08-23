# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Currency.
class MarketData::CurrenciesController < AssetPairsController; end
