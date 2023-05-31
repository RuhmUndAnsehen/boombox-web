# frozen_string_literal: true

module Asset
  extend ActiveSupport::Concern

  included do
    has_many :asset_pairs, as: :asset, dependent: :destroy
    has_many :base_assets, through: :asset_pairs, source: :counter_asset
    has_many :counter_assets, through: :asset_pairs, source: :base_asset
  end

  def in(counter_asset) = AssetPair.of(self).in(counter_asset)
  def of(base_asset)    = AssetPair.in(self).of(base_asset)
end
