class CreateCountriesCurrenciesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :countries, :currencies do |t|
      t.index :country_id
      t.index :currency_id
    end
  end
end
