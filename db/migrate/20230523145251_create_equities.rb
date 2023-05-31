# frozen_string_literal: true

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
