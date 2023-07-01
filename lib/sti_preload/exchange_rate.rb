# frozen_string_literal: true

module StiPreload
  ##
  # Provides eager loading for the ExchangeRate model, to combat issues
  # relating to STI.
  module ExchangeRate
    extend ActiveSupport::Concern

    DESCENDANTS = %w[
      ExchangeRate::Chart::AdjustedRate
      ExchangeRate::Chart::Other
      ExchangeRate::Chart::Rate
      ExchangeRate::NetAssetValue
      ExchangeRate::Other
      ExchangeRate::SettlementRate
      ExchangeRate::Trade
      ExchangeRate::Quote::Ask
      ExchangeRate::Quote::Bid
      ExchangeRate::Quote::Mid
    ].freeze

    included do
      cattr_accessor :preloaded, instance_accessor: false
    end

    class_methods do
      def descendants
        preload_sti unless preloaded

        super
      end

      # Constantizes all types defined in DESCENDANTS.
      def preload_sti
        DESCENDANTS.each(&:constantize)

        self.preloaded = true
      end
    end
  end
end
