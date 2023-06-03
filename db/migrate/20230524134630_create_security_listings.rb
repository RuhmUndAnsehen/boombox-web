# frozen_string_literal: true

##
# Create table security_listings. It provides a many to many interface between
# the polymorphic security and an exchange.
class CreateSecurityListings < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table :security_listings do |t|
      t.references :security, polymorphic: true, null: false
      t.references :exchange, null: false, foreign_key: true
    end
    # rubocop:enable  Rails/CreateTableWithTimestamps
  end
end
