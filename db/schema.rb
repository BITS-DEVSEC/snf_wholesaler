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

ActiveRecord::Schema[8.0].define(version: 2025_03_06_074713) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "snf_core_addresses", force: :cascade do |t|
    t.string "address_type", null: false
    t.string "city", null: false
    t.string "sub_city", null: false
    t.string "woreda"
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snf_core_business_documents", force: :cascade do |t|
    t.bigint "business_id", null: false
    t.integer "document_type", null: false
    t.datetime "verified_at"
    t.bigint "verified_by_id"
    t.datetime "uploaded_at"
    t.boolean "is_verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_snf_core_business_documents_on_business_id"
    t.index ["verified_by_id"], name: "index_snf_core_business_documents_on_verified_by_id"
  end

  create_table "snf_core_businesses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "business_name", null: false
    t.string "tin_number", null: false
    t.integer "business_type", null: false
    t.datetime "verified_at"
    t.integer "verification_status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_snf_core_businesses_on_user_id"
  end

  create_table "snf_core_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_snf_core_categories_on_parent_id"
  end

  create_table "snf_core_customer_groups", force: :cascade do |t|
    t.string "discount_code"
    t.datetime "expire_date"
    t.boolean "is_used"
    t.bigint "group_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_snf_core_customer_groups_on_customer_id"
    t.index ["group_id"], name: "index_snf_core_customer_groups_on_group_id"
  end

  create_table "snf_core_delivery_orders", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "delivery_address", null: false
    t.string "contact_phone", null: false
    t.text "delivery_notes", null: false
    t.datetime "estimated_delivery_time", null: false
    t.datetime "actual_delivery_time"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_snf_core_delivery_orders_on_order_id"
  end

  create_table "snf_core_groups", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_snf_core_groups_on_business_id"
  end

  create_table "snf_core_order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "store_inventory_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", null: false
    t.decimal "subtotal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_snf_core_order_items_on_order_id"
    t.index ["store_inventory_id"], name: "index_snf_core_order_items_on_store_inventory_id"
  end

  create_table "snf_core_orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.integer "status", default: 1, null: false
    t.decimal "total_amount", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_snf_core_orders_on_store_id"
    t.index ["user_id"], name: "index_snf_core_orders_on_user_id"
  end

  create_table "snf_core_products", force: :cascade do |t|
    t.string "sku", null: false
    t.string "name", null: false
    t.string "description"
    t.bigint "category_id", null: false
    t.float "base_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_snf_core_products_on_category_id"
  end

  create_table "snf_core_roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snf_core_store_inventories", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "product_id", null: false
    t.decimal "base_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["product_id"], name: "index_snf_core_store_inventories_on_product_id"
    t.index ["store_id", "product_id"], name: "index_snf_core_store_inventories_on_store_id_and_product_id", unique: true
    t.index ["store_id"], name: "index_snf_core_store_inventories_on_store_id"
  end

  create_table "snf_core_stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.integer "operational_status", default: 1, null: false
    t.bigint "business_id", null: false
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_snf_core_stores_on_address_id"
    t.index ["business_id"], name: "index_snf_core_stores_on_business_id"
  end

  create_table "snf_core_user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_snf_core_user_roles_on_role_id"
    t.index ["user_id"], name: "index_snf_core_user_roles_on_user_id"
  end

  create_table "snf_core_users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.boolean "password_changed", default: false
    t.string "reset_password_token"
  end

  create_table "snf_core_wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "wallet_number", null: false
    t.decimal "balance", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_snf_core_wallets_on_user_id"
    t.index ["wallet_number"], name: "index_snf_core_wallets_on_wallet_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "snf_core_business_documents", "snf_core_businesses", column: "business_id"
  add_foreign_key "snf_core_business_documents", "snf_core_users", column: "verified_by_id"
  add_foreign_key "snf_core_businesses", "snf_core_users", column: "user_id"
  add_foreign_key "snf_core_categories", "snf_core_categories", column: "parent_id"
  add_foreign_key "snf_core_customer_groups", "snf_core_groups", column: "group_id"
  add_foreign_key "snf_core_customer_groups", "snf_core_users", column: "customer_id"
  add_foreign_key "snf_core_delivery_orders", "snf_core_orders", column: "order_id"
  add_foreign_key "snf_core_groups", "snf_core_businesses", column: "business_id"
  add_foreign_key "snf_core_order_items", "snf_core_orders", column: "order_id"
  add_foreign_key "snf_core_order_items", "snf_core_store_inventories", column: "store_inventory_id"
  add_foreign_key "snf_core_orders", "snf_core_stores", column: "store_id"
  add_foreign_key "snf_core_orders", "snf_core_users", column: "user_id"
  add_foreign_key "snf_core_products", "snf_core_categories", column: "category_id"
  add_foreign_key "snf_core_store_inventories", "snf_core_products", column: "product_id"
  add_foreign_key "snf_core_store_inventories", "snf_core_stores", column: "store_id"
  add_foreign_key "snf_core_stores", "snf_core_addresses", column: "address_id"
  add_foreign_key "snf_core_stores", "snf_core_businesses", column: "business_id"
  add_foreign_key "snf_core_user_roles", "snf_core_roles", column: "role_id"
  add_foreign_key "snf_core_user_roles", "snf_core_users", column: "user_id"
  add_foreign_key "snf_core_wallets", "snf_core_users", column: "user_id"
end
