# frozen_string_literal: true

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
