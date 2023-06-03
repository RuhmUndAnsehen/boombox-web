# frozen_string_literal: true

##
# Create table equities. The columns are symbol (typically the ticker symbol)
# and name (human-readable name), both are non-nullable strings.
# It is indexed over symbol.
class CreateEquities < ActiveRecord::Migration[7.0]
  def change
    create_table :equities do |t|
      t.string :symbol, null: false
      t.string :name, null: false

      t.timestamps

      t.index :symbol
    end
  end
end
