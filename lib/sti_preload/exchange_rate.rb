module StiPreload
  module ExchangeRate
    extend ActiveSupport::Concern

    DESCENDANTS = %w[
                     ExchangeRate::Chart
                     ExchangeRate::Chart::Adjusted
                     ExchangeRate::Chart::Other
                     ExchangeRate::Chart::Plain
                     ExchangeRate::NetAssetValue
                     ExchangeRate::Other
                     ExchangeRate::Settlement
                     ExchangeRate::Trade
                    ]

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
        DESCENDANTS.each do |type|
          # logger.debug("Preloading STI type #{type}")
          type.constantize
        end

        self.preloaded = true
      end
    end
  end
end
