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

ActiveRecord::Schema[8.0].define(version: 2025_03_08_050442) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookmarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "shop_id"
    t.index ["shop_id"], name: "fk_rails_e693edfdd5"
    t.index ["user_id"], name: "fk_rails_c1ff6fa4ac"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.date "visit_day"
    t.integer "value"
    t.bigint "user_id", null: false
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_comments_on_shop_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "filters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "free_drink", default: false, null: false
    t.boolean "free_food", default: false, null: false
    t.boolean "private_room", default: false, null: false
    t.boolean "course", default: false, null: false
    t.boolean "midnight", default: false, null: false
    t.boolean "non_smoking", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["free_drink", "free_food", "private_room", "course", "midnight", "non_smoking"], name: "idx_on_free_drink_free_food_private_room_course_mid_ade071a3ac", unique: true
  end

  create_table "keyword_filters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "keyword_id", null: false
    t.bigint "filter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filter_id"], name: "index_keyword_filters_on_filter_id"
    t.index ["keyword_id"], name: "index_keyword_filters_on_keyword_id"
  end

  create_table "keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "word", default: "居酒屋"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shop_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_shop_keywords_on_keyword_id"
    t.index ["shop_id"], name: "index_shop_keywords_on_shop_id"
  end

  create_table "shops", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.integer "phone_number"
    t.string "access"
    t.string "opening_hours"
    t.string "closing_day"
    t.string "budget"
    t.string "number_of_seats"
    t.text "url"
    t.string "unique_number"
    t.text "logo_image"
    t.text "image"
    t.bigint "filter_id"
    t.integer "order"
    t.index ["filter_id"], name: "fk_rails_2a05a1f881"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "shops", on_update: :cascade, on_delete: :cascade
  add_foreign_key "bookmarks", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "shops", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "keyword_filters", "filters", on_update: :cascade
  add_foreign_key "keyword_filters", "keywords", on_update: :cascade
  add_foreign_key "shop_keywords", "keywords", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shop_keywords", "shops", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shops", "filters", on_update: :cascade, on_delete: :cascade
end
