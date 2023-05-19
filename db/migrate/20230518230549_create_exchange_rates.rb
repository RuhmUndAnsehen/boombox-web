class CreateExchangeRates < ActiveRecord::Migration[7.0]
  def change
    change_table :asset_pairs do |t|
      t.remove_index :observed_at
      t.remove_index %i[counter_asset_id counter_asset_type base_asset_id
                        base_asset_type observed_at],
                     name: 'index_asset_pairs_on_all_columns'

      t.remove :base_rate
      t.remove :counter_rate
      t.remove :observed_at

      t.index %i[counter_asset_type counter_asset_id
                 base_asset_type base_asset_id],
              name: 'index_asset_pairs_on_all_columns'
    end

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
end
