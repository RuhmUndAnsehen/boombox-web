# frozen_string_literal: true

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
