# frozen_string_literal: true

class AddExchangeRateColumnToExchangeRates < ActiveRecord::Migration[7.0]
  def change
    change_table :exchange_rates do |t|
      t.float :exchange_rate, null: false

      t.index :exchange_rate
      t.index %i[asset_pair_id type observed_at exchange_rate],
              name: 'index_exchange_rates_on_all_columns'
    end
  end
end
