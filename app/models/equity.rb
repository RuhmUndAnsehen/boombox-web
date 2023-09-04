# frozen_string_literal: true

##
# Equity, typically company stock.
class Equity < ApplicationRecord
  include Asset

  has_one :security_listing, as: :security, dependent: :delete
  has_one :exchange, through: :security_listing

  validates :symbol, format: { without: /:/ }, presence: true
  validates :name, presence: true

  class << self
    ##
    # Returns the record corresponding to the given Equity and Exchange symbols,
    # +nil+ if not found.
    #
    # :call-seq: find_by_compound_symbol(exchange:, equity:) => ...
    def find_by_compound_symbol(**) = _find_by_compound_symbol(**).first

    ##
    # Like #find_by_compound_symbol, but raises an Error if no record can be
    # found.
    def find_by_compound_symbol!(**) = _find_by_compound_symbol(**).first!

    private

    def _find_by_compound_symbol(exchange: nil, equity: nil)
      with_exchange_symbol.where(symbol: equity)
                          .merge(Exchange.where(symbol: exchange))
    end
  end

  ##
  # Returns a relation that includes the symbol of the exchange the equities are
  # listed on.
  #
  # Selects all of Equity's columns, plus Exchange#symbol.
  scope :with_exchange, -> { includes(:exchange).references(:exchange) }
  singleton_class.__send__(:alias_method, :with_exchange_symbol, :with_exchange)

  ##
  # Returns +exchange.symbol+.
  def exchange_symbol = exchange&.symbol

  def to_asset_pair_params
    counter_asset_id = Currency.active
                               .joins(countries: { exchanges: :equities })
                               .merge(Equity.where(id:))
                               .reorder(:id).pick(:id) || Currency.XXX.id

    {
      asset_pair: {
        base_asset_id: id, base_asset_type: self.class,
        counter_asset_id:, counter_asset_type: 'Currency'
      }
    }
  end

  def to_param
    return super unless association(:exchange).loaded?

    [exchange_symbol, symbol].compact.join(':')
  end

  def to_human_s(*, **opts)
    default = association(:exchange).loaded? ? to_param : symbol

    super(*, **opts.merge(default:))
  end
end
