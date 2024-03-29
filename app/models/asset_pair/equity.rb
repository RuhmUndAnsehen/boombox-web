# frozen_string_literal: true

##
# Class enabling the rendering of AssetPairs in a dedicated
# equity controller while maintaining the ability to manage
# AssetPairs regardless of type in the AssetPairsController.
class AssetPair::Equity < AssetPair
  class << self
    def preload_all(...) = super.preload(base_asset: :exchange)
  end
end
