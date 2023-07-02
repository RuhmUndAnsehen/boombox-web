# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_01_221254) do
  create_table "asset_pairs", force: :cascade do |t|
    t.string "base_asset_type", null: false
    t.integer "base_asset_id", null: false
    t.string "counter_asset_type", null: false
    t.integer "counter_asset_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_asset_type", "base_asset_id"], name: "index_asset_pairs_on_base_asset"
    t.index ["counter_asset_type", "counter_asset_id", "base_asset_type", "base_asset_id"], name: "index_asset_pairs_on_all_columns"
    t.index ["counter_asset_type", "counter_asset_id"], name: "index_asset_pairs_on_counter_asset"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "alpha2_code", limit: 2, null: false
    t.string "alpha3_code", limit: 3, null: false
    t.integer "numeric_code", limit: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alpha2_code"], name: "index_countries_on_alpha2_code", unique: true
    t.index ["alpha3_code"], name: "index_countries_on_alpha3_code", unique: true
    t.index ["numeric_code"], name: "index_countries_on_numeric_code", unique: true
  end

  create_table "countries_currencies", id: false, force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "currency_id", null: false
    t.index ["country_id", "currency_id"], name: "index_countries_currencies_on_country_id_and_currency_id"
    t.index ["currency_id", "country_id"], name: "index_countries_currencies_on_currency_id_and_country_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "currency"
    t.string "alphabetic_code", limit: 3
    t.integer "numeric_code", limit: 3
    t.integer "minor_unit", limit: 1
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alphabetic_code", "active"], name: "index_currencies_on_alphabetic_code_and_active"
    t.index ["numeric_code", "active"], name: "index_currencies_on_numeric_code_and_active"
  end

  create_table "equities", force: :cascade do |t|
    t.string "symbol", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_equities_on_name"
    t.index ["symbol"], name: "index_equities_on_symbol"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.integer "asset_pair_id", null: false
    t.integer "base_rate", null: false
    t.integer "counter_rate", null: false
    t.datetime "observed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.float "exchange_rate", null: false
    t.index ["asset_pair_id"], name: "index_exchange_rates_on_asset_pair_id"
    t.index ["exchange_rate", "type", "asset_pair_id"], name: "index_exchange_rates_on_exchange_rate_and_type_and_asset_pair_id"
    t.index ["observed_at", "exchange_rate", "type", "asset_pair_id"], name: "index_exchange_rates_on_all_columns"
    t.index ["observed_at", "type", "asset_pair_id"], name: "index_exchange_rates_on_observed_at_and_type_and_asset_pair_id"
    t.index ["type", "observed_at", "asset_pair_id"], name: "index_exchange_rates_on_type_and_observed_at_and_asset_pair_id"
    t.index ["type"], name: "index_exchange_rates_on_type"
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer "country_id", null: false
    t.string "symbol", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone"
    t.index ["country_id"], name: "index_exchanges_on_country_id"
    t.index ["name", "country_id"], name: "index_exchanges_on_name_and_country_id"
    t.index ["symbol"], name: "index_exchanges_on_symbol", unique: true
  end

  create_table "options", force: :cascade do |t|
    t.integer "underlying_id", null: false
    t.datetime "expires_at", null: false
    t.integer "type", limit: 1, null: false
    t.integer "style", limit: 1, null: false
    t.float "strike", null: false
    t.integer "strike_denominator", null: false
    t.integer "strike_numerator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_options_on_expires_at"
    t.index ["strike", "expires_at", "type", "underlying_id"], name: "index_options_on_major_columns"
    t.index ["underlying_id"], name: "index_options_on_underlying_id"
  end

  create_table "security_listings", force: :cascade do |t|
    t.string "security_type", null: false
    t.integer "security_id", null: false
    t.integer "exchange_id", null: false
    t.index ["exchange_id", "security_type", "security_id"], name: "index_security_listings_on_exchange_and_security"
    t.index ["security_type", "security_id", "exchange_id"], name: "index_security_listings_on_security_and_exchange"
  end

  add_foreign_key "exchange_rates", "asset_pairs"
  add_foreign_key "exchanges", "countries"
  add_foreign_key "options", "asset_pairs", column: "underlying_id"
  add_foreign_key "security_listings", "exchanges"
end
