# frozen_string_literal: true

# Undoes the change that removed uniqueness from the #symbol column and instead
# made the symbol-country combination unique.
class FixExchangeIndices < ActiveRecord::Migration[7.0]
  def change
    change_table :exchanges do |t|
      t.remove_index %i[symbol country_id], unique: true

      t.index :symbol, unique: true
    end
  end
end
