# frozen_string_literal: true

##
# Creates a table exchange_rates with columns asset_pair_id,  base_rate,
# counter_rate and observed_at, which were previously part of asset_pairs.
# Therefore, they are getting removed from asset_pairs along with their indices.
# Adds indices for observed_at, and composite asset_pair_id and observed_at.
class CreateExchangeRates < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    change_table :asset_pairs do |t|
      t.remove_index :observed_at
      t.remove_index %i[counter_asset_id counter_asset_type base_asset_id
                        base_asset_type observed_at],
                     name: 'index_asset_pairs_on_all_columns'

      t.index %i[counter_asset_type counter_asset_id
                 base_asset_type base_asset_id],
              name: 'index_asset_pairs_on_all_columns'
    end
    remove_column :asset_pairs, :base_rate, :integer, null: false
    remove_column :asset_pairs, :counter_rate, :integer, null: false
    remove_column :asset_pairs, :observed_at, :datetime

    create_table :exchange_rates do |t|
      t.references :asset_pair, null: false, foreign_key: true
      t.integer :base_rate, null: false
      t.integer :counter_rate, null: false
      t.datetime :observed_at, null: false

      t.timestamps

      t.index :observed_at
      t.index %i[asset_pair_id observed_at]
    end
  end
  # rubocop:enable  Metrics/MethodLength
end
