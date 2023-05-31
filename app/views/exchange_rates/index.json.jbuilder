# frozen_string_literal: true

json.array! @exchange_rates, partial: 'exchange_rates/exchange_rate',
                             as: :exchange_rate
