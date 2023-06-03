# frozen_string_literal: true

##
# Create table exchanges with references to country and string columns symbol
# and name. Symbol is non-nullable, a requirement we're omitting for the name
# incase we need some kind of meta or pseudo exchange.
# Uniquely indexed over symbol.
class CreateExchanges < ActiveRecord::Migration[7.0]
  def change
    create_table :exchanges do |t|
      t.references :country, null: false, foreign_key: true
      t.string :symbol, null: false
      t.string :name

      t.timestamps
    end
    add_index :exchanges, :symbol, unique: true
  end
end
