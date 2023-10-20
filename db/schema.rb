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

ActiveRecord::Schema.define(version: 2023_10_15_092713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "car_rankings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.decimal "rank_score", precision: 10, scale: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_id"], name: "index_car_rankings_on_car_id"
    t.index ["user_id"], name: "index_car_rankings_on_user_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "model"
    t.bigint "brand_id", null: false
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_cars_on_brand_id"
  end

  create_table "preferred_brands", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_preferred_brands_on_brand_id"
    t.index ["user_id"], name: "index_preferred_brands_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.int8range "preferred_price_range"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cars", "brands"
  add_foreign_key "preferred_brands", "brands"
  add_foreign_key "preferred_brands", "users"
end
