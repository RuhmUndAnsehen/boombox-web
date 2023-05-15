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
