# frozen_string_literal: true

class AssetPair::Currency < AssetPair
  private

  def _to_param
    return id.to_i unless association(:counter_asset).loaded?

    "#{base_asset.to_param}#{counter_asset.to_param}"
  end
end
