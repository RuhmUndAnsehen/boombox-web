# frozen_string_literal: true

##
# Create table currencies for ISO-3166 data, with string columns currency
# (name) and alphabet_code, integer columns numeric_code and minor_unit, add
# a boolean column for if the currency is currently active.
# Indexed over the code columns.
class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :currency
      t.string :alphabetic_code, limit: 3
      t.integer :numeric_code, limit: 3
      t.integer :minor_unit, limit: 1
      t.boolean :active

      t.timestamps
    end
    add_index :currencies, :alphabetic_code
    add_index :currencies, :numeric_code
  end
end
