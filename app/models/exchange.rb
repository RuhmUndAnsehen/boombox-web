# frozen_string_literal: true

##
# A securities exchange.
class Exchange < ApplicationRecord
  belongs_to :country

  has_many :security_listings, dependent: :delete_all
  has_many :equities, through: :security_listings, source: :security,
                      source_type: 'Equity'

  validates :symbol, format: { without: /:/ }, uniqueness: true, presence: true
  validates :timezone, timezone: true

  class << self
    ##
    # Returns the first result of a case insensitive match between +symbol+ and
    # the #symbol column.
    #
    # Raises an error if not found.
    # TODO: Reconsider method naming so we dont have to disable Rubocop for
    #       calls to it.
    def find_by_symbol_case_insensitive!(symbol)
      symbol_like_id = arel_table[:symbol].matches(sanitize_sql_like(symbol))
      where(symbol_like_id).first!
    end

    ##
    # Like #find_by_symbol_case_insensitive!, but returns +nil+ if not found.
    def find_by_symbol_case_insensitive(symbol)
      find_by!(symbol_case_insensitive: symbol)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    ##
    # Returns the record where the #symbol or the #id column match +id+.
    #
    # If not found, does a case insensitive search of the #symbol column.
    # Raises ActiveRecord::RecordNotFound if not found.
    def smart_find!(id) = where(symbol: id).or(where(id:)).first!

    ##
    # Like #smart_find!, but returns +nil+ if not found.
    def smart_find(id)
      smart_find!(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  scope :equities,
        -> { Equity.with_exchange_symbol.where(exchanges: self) }

  def to_param = symbol
end
