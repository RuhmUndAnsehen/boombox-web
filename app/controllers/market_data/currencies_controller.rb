# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Currency.
class MarketData::CurrenciesController < AssetPairsController
  class << self
    def find_asset_pair_by_string(id)
      base_asset_symbol, counter_asset_symbol = *parse_compound_symbol(id)

      base_asset = find_base_asset(base_asset_symbol)
      counter_asset = find_counter_asset(counter_asset_symbol)

      asset_pairs.where(base_asset:, counter_asset:).first!
    end

    def find_base_asset(symbol)
      Currency.find_by!(alpha3_code: symbol)
    end
    alias find_counter_asset find_base_asset

    def parse_compound_symbol(symbol)
      symbol.match(
        /\A(?<base_asset>[[:upper:]]{3})(?<counter_asset>[[:upper:]]{3})\z/
      )&.values_at(:base_asset, :counter_asset)
    end
  end
end
