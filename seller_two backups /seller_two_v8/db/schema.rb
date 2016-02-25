# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151014141202) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "album_images", force: :cascade do |t|
    t.string   "file_name",      limit: 255
    t.text     "cloudinary_url", limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "thumbnail",      limit: 255
    t.integer  "product_id",     limit: 4
  end

  create_table "albums", force: :cascade do |t|
    t.integer  "seller_id",    limit: 4
    t.integer  "created_by",   limit: 4
    t.integer  "images_count", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "cat_picture",   limit: 255
    t.string  "name",          limit: 255
    t.integer "order_no",      limit: 4,   default: 0
    t.integer "parent_id",     limit: 4
    t.string  "status",        limit: 255, default: "active"
    t.string  "category_type", limit: 15,  default: "CATEGORY"
    t.string  "old_name",      limit: 255
  end

  create_table "category_mappings", force: :cascade do |t|
    t.string   "category",                   limit: 255
    t.string   "sub_category",               limit: 255
    t.integer  "shopo_category_id",          limit: 4
    t.integer  "shopo_parent_category_id",   limit: 4
    t.string   "shopo_category_name",        limit: 255
    t.string   "shopo_parent_category_name", limit: 255
    t.integer  "seller_id",                  limit: 4
    t.integer  "mapped_by",                  limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "master_category_mappings", force: :cascade do |t|
    t.integer  "third_level_id",          limit: 4
    t.integer  "revised_second_level_id", limit: 4
    t.integer  "current_second_level_id", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "products_three_level_categories", force: :cascade do |t|
    t.integer  "product_id",     limit: 4
    t.integer  "third_level_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "revised_two_level_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4
    t.integer  "level",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "three_level_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4,   default: 0
    t.integer  "level",      limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "unresolved_products", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "product_id", limit: 4
  end

  create_table "uploads", force: :cascade do |t|
    t.integer  "uploaded_by",       limit: 4
    t.integer  "listings_count",    limit: 4
    t.integer  "categories_count",  limit: 4
    t.string   "upload_type",       limit: 255
    t.string   "file_name",         limit: 255
    t.integer  "seller_id",         limit: 4
    t.integer  "mobile_number",     limit: 4
    t.text     "sellers_list",      limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "city_name",         limit: 255
    t.integer  "total_listings",    limit: 4
    t.integer  "errors_count",      limit: 4
    t.text     "error_product_ids", limit: 65535
    t.string   "cloudinary_type",   limit: 255
    t.boolean  "validate_image"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
