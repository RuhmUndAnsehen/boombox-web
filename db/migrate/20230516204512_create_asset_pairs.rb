# frozen_string_literal: true

##
# Create table asset_pairs with polymorphic references base_asset and
# counter_asset, corresponding integer columns base_rate and counter_rate,
# and datetime observed_at.
# Adds lots of indices, too.
class CreateAssetPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_pairs do |t|
      t.references :base_asset, polymorphic: true, null: false
      t.references :counter_asset, polymorphic: true, null: false
      t.integer :base_rate, null: false
      t.integer :counter_rate, null: false
      t.datetime :observed_at

      t.timestamps
    end
    add_index :asset_pairs, %i[base_asset_id base_asset_type]
    add_index :asset_pairs, %i[counter_asset_id counter_asset_type]
    add_index :asset_pairs, :observed_at
    add_index :asset_pairs,
              %i[counter_asset_id counter_asset_type base_asset_id
                 base_asset_type observed_at],
              name: 'index_asset_pairs_on_all_columns'
  end
end
