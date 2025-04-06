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

ActiveRecord::Schema[8.0].define(version: 2025_04_06_095533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "delivery_partners", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number", null: false
    t.boolean "verified", default: false
    t.text "full_address"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_delivery_partners_on_email_address", unique: true
  end

  create_table "establishments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "establishment_type", null: false
    t.string "full_address", null: false
    t.string "city", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "phone_number", null: false
    t.string "email_address", null: false
    t.decimal "rating", precision: 2, scale: 1, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_establishments_on_city"
    t.index ["email_address"], name: "index_establishments_on_email_address", unique: true
    t.index ["name"], name: "index_establishments_on_name", unique: true
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "establishment_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id", "product_id"], name: "index_inventories_on_establishment_id_and_product_id", unique: true
    t.index ["establishment_id"], name: "index_inventories_on_establishment_id"
    t.index ["product_id"], name: "index_inventories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "establishment_id", null: false
    t.string "name", null: false
    t.string "description"
    t.decimal "price", precision: 5, scale: 2, null: false
    t.decimal "rating", precision: 2, scale: 1, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id", "name"], name: "index_products_on_establishment_id_and_name", unique: true
    t.index ["establishment_id"], name: "index_products_on_establishment_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_sessions_on_resource"
    t.index ["resource_type", "resource_id"], name: "index_sessions_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number", null: false
    t.string "email_address", null: false
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "inventories", "establishments"
  add_foreign_key "inventories", "products"
  add_foreign_key "products", "establishments"
end
