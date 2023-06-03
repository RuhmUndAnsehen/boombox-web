# frozen_string_literal: true

##
# Create table countries for ISO-4217 data, with columns for country name,
# alphanumeric 2- and 3-letter codes, and an integer column for the numeric
# code.
# Uniquely indexed on all columns except the name.
class CreateCountries < ActiveRecord::Migration[7.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :alpha2_code, limit: 2, null: false
      t.string :alpha3_code, limit: 3, null: false
      t.integer :numeric_code, limit: 3, null: false

      t.timestamps
    end
    add_index :countries, :alpha2_code, unique: true
    add_index :countries, :alpha3_code, unique: true
    add_index :countries, :numeric_code, unique: true
  end
end
