class CreateSecurityListings < ActiveRecord::Migration[7.0]
  def change
    create_table :security_listings do |t|
      t.references :security, polymorphic: true, null: false
      t.references :exchange, null: false, foreign_key: true
    end
  end
end
