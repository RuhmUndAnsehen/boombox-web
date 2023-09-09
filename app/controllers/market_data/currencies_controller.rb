# frozen_string_literal: true

##
# Inherits from AssetPairsController to explicitly handle AssetPairs where
# #base_asset is of type Currency.
class MarketData::CurrenciesController < AssetPairsController
  class << self
    def parse_compound_symbol(symbol)
      symbol.match(/\A(?<base>[[:upper:]]{3})(?<quote>[[:upper:]]{3})\z/)
    end
  end

  delegate :parse_compound_symbol, to: :class
  private :parse_compound_symbol

  private

  def set_asset_pair
    super
  rescue ActionController::RoutingError
    parse_compound_symbol(params[:id]) => base:, quote:

    base_asset = Currency.where(alpha3_code: base)
    counter_asset = Currency.where(alpha3_code: quote)

    @asset_pair = asset_pairs.where(base_asset:, counter_asset:).first!
  end
end
