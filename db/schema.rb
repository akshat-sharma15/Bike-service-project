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

ActiveRecord::Schema[7.0].define(version: 2024_07_28_174859) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "bikes", force: :cascade do |t|
    t.string "info"
    t.string "regstration_num"
    t.string "status"
    t.string "service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_center_id", null: false
    t.string "rate"
    t.index ["service_center_id"], name: "index_bikes_on_service_center_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bike_id", null: false
    t.bigint "service_center_id", null: false
    t.decimal "cost", default: "0.0"
    t.date "booking_date"
    t.integer "rental_days"
    t.date "return_date"
    t.bigint "client_user_id", null: false
    t.string "status"
    t.index ["bike_id"], name: "index_bookings_on_bike_id"
    t.index ["client_user_id"], name: "index_bookings_on_client_user_id"
    t.index ["service_center_id"], name: "index_bookings_on_service_center_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.string "star"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_user_id", null: false
    t.bigint "service_center_id", null: false
    t.index ["client_user_id"], name: "index_ratings_on_client_user_id"
    t.index ["service_center_id"], name: "index_ratings_on_service_center_id"
  end

  create_table "records", force: :cascade do |t|
    t.string "date"
    t.string "details"
    t.string "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "revenues", force: :cascade do |t|
    t.bigint "service_center_id", null: false
    t.date "date", null: false
    t.decimal "revenue", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_center_id", "date"], name: "index_revenues_on_service_center_id_and_date", unique: true
    t.index ["service_center_id"], name: "index_revenues_on_service_center_id"
  end

  create_table "service_centers", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_owner_id", null: false
    t.integer "total_slots"
    t.index ["service_owner_id"], name: "index_service_centers_on_service_owner_id"
  end

  create_table "slot_types", force: :cascade do |t|
    t.string "type"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slots", force: :cascade do |t|
    t.string "status"
    t.string "service_type"
    t.string "booking_date"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_user_id", null: false
    t.bigint "service_center_id", null: false
    t.decimal "cost", precision: 10, scale: 2
    t.index ["client_user_id"], name: "index_slots_on_client_user_id"
    t.index ["service_center_id"], name: "index_slots_on_service_center_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bikes", "service_centers"
  add_foreign_key "bookings", "bikes"
  add_foreign_key "bookings", "service_centers"
  add_foreign_key "bookings", "users", column: "client_user_id"
  add_foreign_key "ratings", "service_centers"
  add_foreign_key "ratings", "users", column: "client_user_id"
  add_foreign_key "revenues", "service_centers"
  add_foreign_key "service_centers", "users", column: "service_owner_id"
  add_foreign_key "slots", "service_centers"
  add_foreign_key "slots", "users", column: "client_user_id"
end
