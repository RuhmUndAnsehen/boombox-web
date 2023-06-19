# frozen_string_literal: true

##
# I'm not satisfied with how I constructed indices in previous migrations.
# This one attempts to fix that. Indices are now built with ORDER performance in
# mind.
class OptimizeIndices < ActiveRecord::Migration[7.0]
  def change
    change_table :countries_currencies do |t|
      t.remove_index :country_id
      t.remove_index :currency_id

      t.index %i[country_id currency_id]
      t.index %i[currency_id country_id]
    end

    change_table :currencies do |t|
      t.remove_index :alphabetic_code
      t.remove_index :numeric_code

      t.index %i[alphabetic_code active]
      t.index %i[numeric_code active]
    end

    change_table :equities do |t|
      t.index :name
    end

    change_table :exchange_rates do |t|
      t.remove_index %i[asset_pair_id observed_at]
      t.remove_index %i[asset_pair_id type observed_at exchange_rate],
                     name: 'index_exchange_rates_on_all_columns'
      t.remove_index %i[asset_pair_id type observed_at]
      t.remove_index :exchange_rate
      t.remove_index :observed_at
      t.remove_index %i[type observed_at]

      t.index %i[exchange_rate type asset_pair_id]
      t.index %i[observed_at type asset_pair_id]
      t.index %i[type observed_at asset_pair_id]
      t.index %i[observed_at exchange_rate type asset_pair_id],
              name: 'index_exchange_rates_on_all_columns'
    end

    change_table :exchanges do |t|
      t.remove_index :symbol, unique: true

      t.index %i[name country_id]
      t.index %i[symbol country_id], unique: true
    end

    change_table :security_listings do |t|
      t.remove_index :exchange_id
      t.remove_index %i[security_type security_id]

      t.index %i[exchange_id security_type security_id],
              name: 'index_security_listings_on_exchange_and_security'
      t.index %i[security_type security_id exchange_id],
              name: 'index_security_listings_on_security_and_exchange'
    end
  end
end
