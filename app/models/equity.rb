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
    # Returns the name of the attribute that's used for the associated
    # exchange's symbol column.
    def exchange_key = 'exchange_symbol'

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
  scope :with_exchange_symbol,
        lambda {
          select("#{table_name}.*",
                 "#{Exchange.table_name}.symbol AS #{exchange_key}")
            .left_outer_joins(:exchange)
        }

  ##
  # Returns Equity.exchange_key.
  def exchange_key = self.class.exchange_key

  ##
  # Returns the value of the attribute denoted by #exchange_key.
  def exchange_symbol = attributes[exchange_key]

  def to_param
    return id.to_s unless attributes.key?(exchange_key)

    "#{exchange_symbol}:#{symbol}"
  end
end
