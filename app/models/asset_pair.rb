class AssetPair < ApplicationRecord
  belongs_to :base_asset, polymorphic: true
  belongs_to :counter_asset, polymorphic: true

  has_many :exchange_rates, dependent: :destroy

  validates_associated :base_asset
  validates_associated :counter_asset

  # :section: Asset based selectors

  scope :in, ->(counter_asset) { where(counter_asset:) }
  scope :of, ->(base_asset) { where(base_asset:) }

  # :section: ExchangeRate selectors

  scope :exchange_rates, -> { ExchangeRate.where(asset_pair: self) }

  ExchangeRate.descendants.each do |type|
    scope type.to_s[14..].remove('::').tableize.to_sym,
          -> { exchange_rates.of_type(type) }
  end
end
