# frozen_string_literal: true

##
# Associates two polymorphic assets into one asset pair. Typically, this would
# be with an Equity, Option (tbd) or Currency as #base_asset, and a(nother)
# Currency as #counter_asset.
# AssetPairs have many #exchange_rates, which represent prices or quotes on the
# AssetPair.
#
# Note: If the relation returned by the associated block groups by the column
# +:asset_pair_id+, this column will be replaced by +'asset_pairs.id'+ to
# preserve the Left Outer Join generated by ::includes.
class AssetPair < ApplicationRecord
  class << self
    ##
    # Returns the default +model_name+ for AssetPair, and a patched one for
    # subclasses.
    #
    # In subclasses, the following changes are done to +model_name+:
    # [i18n_key]
    #             Derived from +subclass::basename+
    # [route_key]
    #             Derived from +subclass::basename+ and namespaced in
    #             +'market_data/'+
    # [singular_route_key]
    #             +route_key+, singularized
    def model_name
      return super if self == AssetPair

      # rubocop:disable Naming/MemoizedInstanceVariableName
      @_model_name ||= AssetPair.model_name.dup.tap do |model_name|
        model_name.i18n_key = basename.underscore.to_sym
        model_name.route_key = ActiveSupport::Inflector.pluralize(
          "market_data_#{model_name.__send__(:_singularize, basename)}", :en
        )
        model_name.singular_route_key =
          ActiveSupport::Inflector.singularize(model_name.route_key)
      end
      # rubocop:enable  Naming/MemoizedInstanceVariableName
    end

    def includes_exchange_rates
      query = includes(:exchange_rates).references(:exchange_rates)
      return query unless block_given?

      other = yield ExchangeRate
      other.group_values.map! do |value|
        value.in?([:asset_pair_id, 'asset_pair_id']) ? 'asset_pairs.id' : value
      end
      query.merge(other)
    end

    def preload_all(&)
      preload(:base_asset, :counter_asset).includes_exchange_rates(&)
    end

    private

    def inherited(subclass)
      super
      subclass.__send__(:default_scope) { of_base_type(subclass.basename) }
    end
  end

  belongs_to :base_asset, polymorphic: true
  belongs_to :counter_asset, polymorphic: true

  has_many :exchange_rates, dependent: :destroy
  has_many :options, inverse_of: :underlying, foreign_key: :underlying_id,
                     dependent: :destroy

  # TODO: The default error message is referring to this attribute, but the
  #       constraint actually prevents creation of duplicate AssetPairs.
  validates :counter_asset_type,
            uniqueness: {
              scope: %i[counter_asset_id base_asset_type base_asset_id]
            }

  # :section: Asset based selectors

  scope :in, ->(counter_asset) { where(counter_asset:) }
  scope :of, ->(base_asset) { where(base_asset:) }
  scope :of_base_type, ->(type) { where(base_asset_type: type.to_s) }

  # :section: ExchangeRate selectors

  scope :exchange_rates, -> { ExchangeRate.where(asset_pair: self) }

  ##
  # Defines a bunch of scopes that filter associated exchange_rates based on
  # their types.
  #
  # Methods are named after their types.
  # :call-seq:
  #     chart_adjusted_rates => ...
  #     chart_others         => ...
  #     chart_rates          => ...
  #     charts               => ...
  #     net_asset_values     => ...
  #     others               => ...
  #     quote_asks           => ...
  #     quote_bids           => ...
  #     quote_mids           => ...
  #     settlement_rates     => ...
  #     trades               => ...
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

  def to_param
    return super if instance_of?(AssetPair) || !association(:base_asset).loaded?

    _to_param
  end

  private

  def _to_param = base_asset.to_param
end
