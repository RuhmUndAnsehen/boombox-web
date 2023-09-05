# frozen_string_literal: true

module EquitiesController::Finders
  extend ActiveSupport::Concern

  class_methods do
    def find_equity(id) # rubocop:disable Metrics/MethodLength
      matches = parse_compound_symbol(id)

      case matches
      in id: String => id
        Equity.find(id)
      in exchange: String => exchange, equity: String => equity
        Equity.find_by_compound_symbol!(exchange:, equity:)
      in equity: String => symbol
        Equity.find_by!(symbol:)
      else
        raise ActionController::RoutingError, "invalid id: #{id}"
      end
    rescue ActiveRecord::RecordNotFound => e
      raise e unless block_given?

      # Use deconstruct_keys instead of named_captures because the latter
      # returns String keys, while the former returns Symbol keys.
      yield(**matches.deconstruct_keys(%i[equity exchange]), error: e)
    end

    ##
    # Returns the Exchange for the given +symbol+. Performs a case insensitive
    # search if it can't be found. If that fails, too, raises.
    def find_exchange(symbol)
      Exchange.find_by!(symbol:) if symbol.present?
    rescue ActiveRecord::RecordNotFound
      # rubocop:disable Rails/DynamicFindBy
      Exchange.find_by_symbol_case_insensitive!(symbol) if symbol.present?
      # rubocop:enable  Rails/DynamicFindBy
    end

    # :nodoc:
    def parse_compound_symbol(symbol)
      symbol.match(
        /\A(?<id>[[:digit:]]+)|(?:(?<exchange>[^:]+):)?(?<equity>[^:]+)\z/
      )
    end
  end

  included do
  end

  delegate :find_equity, :find_exchange, :parse_compound_symbol, to: :class
  private :find_equity, :find_exchange, :parse_compound_symbol
end
