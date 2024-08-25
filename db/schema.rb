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

ActiveRecord::Schema[7.2].define(version: 2024_08_25_153039) do
  create_table "coordinates", force: :cascade do |t|
    t.text "address", null: false
    t.string "lat", null: false
    t.text "lon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_coordinates_on_address", unique: true
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "ip", null: false
    t.text "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip"], name: "index_ip_addresses_on_ip", unique: true
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", limit: 1024, null: false
    t.binary "value", limit: 536870912, null: false
    t.datetime "created_at", null: false
    t.integer "key_hash", limit: 8, null: false
    t.integer "byte_size", limit: 4, null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end
end
