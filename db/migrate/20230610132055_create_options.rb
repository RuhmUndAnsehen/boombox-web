# frozen_string_literal: true

##
# Create table options. Its columns are #underlying (which references to
# asset_pairs instead), #expires_at (expiration timestamp), #type (enum
# put/call), #style (exercise style, enum european/american) and #strike
# (exercise price).
# It is indexed over #expires_at and [#underlying, #expires_at, #strike].
class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.references :underlying, null: false,
                                foreign_key: { to_table: :asset_pairs }
      t.datetime :expires_at, null: false
      t.integer :type, limit: 1, null: false
      t.integer :style, limit: 1, null: false
      t.rational :strike, null: false

      t.timestamps

      t.index :expires_at
      t.index %i[strike expires_at type underlying_id],
              name: 'index_options_on_major_columns'
    end
  end
end
