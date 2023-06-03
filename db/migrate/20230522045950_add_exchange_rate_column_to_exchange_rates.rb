# frozen_string_literal: true

##
# Add an exchange_rate float column to table exchange_rates. The column is not
# exposed to the user through the model. Instead, it purely serves for faster
# querying.
# Also adds an index over the column alone, plus a composite over asset_pair_id,
# type, observed_at and exchange_rate.
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
