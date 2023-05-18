class RemoveRedundantIndices < ActiveRecord::Migration[7.0]
  def change
    remove_index :asset_pairs, %i[base_asset_id base_asset_type]
    remove_index :asset_pairs, %i[counter_asset_id counter_asset_type]
  end
end
