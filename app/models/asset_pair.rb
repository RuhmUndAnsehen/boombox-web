# frozen_string_literal: true

##
# Associates two polymorphic assets into one asset pair. Typically, this would
# be with an Equity, Option (tbd) or Currency as #base_asset, and a(nother)
# Currency as #counter_asset.
# AssetPairs have many #exchange_rates, which represent prices or quotes on the
# AssetPair.
class AssetPair < ApplicationRecord
  class << self
    def includes_exchange_rates
      query = includes(:exchange_rates).references(:exchange_rates)
      return query unless block_given?

      query.merge(yield(ExchangeRate))
    end

    def preload_all(&)
      preload(:base_asset, :counter_asset).includes_exchange_rates(&)
    end
  end

  belongs_to :base_asset, polymorphic: true
  belongs_to :counter_asset, polymorphic: true

  has_many :exchange_rates, dependent: :destroy
  has_many :options, foreign_key: :underlying_id, dependent: :destroy

  # TODO: The default error message is referring to this attribute, but the
  #       constraint actually prevents creation of duplicate AssetPairs.
  validates :counter_asset_type,
            uniqueness: {
              scope: %i[counter_asset_id base_asset_type base_asset_id]
            }

  # :section: Asset based selectors

  scope :in, ->(counter_asset) { where(counter_asset:) }
  scope :of, ->(base_asset) { where(base_asset:) }

  # :section: ExchangeRate selectors

  scope :exchange_rates, -> { ExchangeRate.where(asset_pair: self) }

  ExchangeRate.descendants.each do |type|
    scope type.to_s[14..].remove('::').tableize.to_sym,
          -> { exchange_rates.of_type(type) }
  end

  def to_human_s(*args, **opts)
    base_asset = self.base_asset.to_human_s
    counter_asset = self.counter_asset.to_human_s

    super(*args, **opts.merge(base_asset:, counter_asset:,
                              default: "#{base_asset} (#{counter_asset})"))
  end
end
