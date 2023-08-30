# frozen_string_literal: true

##
# Class enabling the rendering of AssetPairs in a dedicated
# forex controller while maintaining the ability to manage
# AssetPairs regardless of type in the AssetPairsController.
class AssetPair::Currency < AssetPair
  private

  def _to_param
    return id.to_i unless association(:counter_asset).loaded?

    "#{base_asset.to_param}#{counter_asset.to_param}"
  end
end
