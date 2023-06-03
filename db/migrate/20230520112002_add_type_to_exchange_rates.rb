# frozen_string_literal: true

##
# Adds an STI type column to exchange rates.
# Adds an index over type, and composite indices for type and observed_at, as
# well as for asset_pair_id, type and observed_at.
class AddTypeToExchangeRates < ActiveRecord::Migration[7.0]
  def change
    change_table :exchange_rates do |t|
      t.string :type, null: false

      t.index :type
      t.index %i[type observed_at]
      t.index %i[asset_pair_id type observed_at]
    end
  end
end
