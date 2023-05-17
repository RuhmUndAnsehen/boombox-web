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

ActiveRecord::Schema[7.0].define(version: 2023_05_16_204512) do
  create_table "asset_pairs", force: :cascade do |t|
    t.string "base_asset_type", null: false
    t.integer "base_asset_id", null: false
    t.string "counter_asset_type", null: false
    t.integer "counter_asset_id", null: false
    t.integer "base_rate", null: false
    t.integer "counter_rate", null: false
    t.datetime "observed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_asset_id", "base_asset_type"], name: "index_asset_pairs_on_base_asset_id_and_base_asset_type"
    t.index ["base_asset_type", "base_asset_id"], name: "index_asset_pairs_on_base_asset"
    t.index ["counter_asset_id", "counter_asset_type", "base_asset_id", "base_asset_type", "observed_at"], name: "index_asset_pairs_on_all_columns"
    t.index ["counter_asset_id", "counter_asset_type"], name: "index_asset_pairs_on_counter_asset_id_and_counter_asset_type"
    t.index ["counter_asset_type", "counter_asset_id"], name: "index_asset_pairs_on_counter_asset"
    t.index ["observed_at"], name: "index_asset_pairs_on_observed_at"
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
    t.index ["country_id"], name: "index_countries_currencies_on_country_id"
    t.index ["currency_id"], name: "index_countries_currencies_on_currency_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "currency"
    t.string "alphabetic_code", limit: 3
    t.integer "numeric_code", limit: 3
    t.integer "minor_unit", limit: 1
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alphabetic_code"], name: "index_currencies_on_alphabetic_code"
    t.index ["numeric_code"], name: "index_currencies_on_numeric_code"
  end

end
