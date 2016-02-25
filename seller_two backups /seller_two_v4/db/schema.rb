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

ActiveRecord::Schema.define(version: 20151015123154) do

  create_table "address", force: :cascade do |t|
    t.string   "street",     limit: 1000
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.integer  "pin",        limit: 8,    null: false
    t.string   "phone",      limit: 255
    t.integer  "user_id",    limit: 8,    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",       limit: 255
    t.string   "status",     limit: 255
  end

  add_index "address", ["user_id"], name: "FK_jfkhwekfjnksd123", using: :btree

  create_table "bank_details", force: :cascade do |t|
    t.string  "account_number", limit: 255
    t.string  "created_at",     limit: 255
    t.string  "ifsc",           limit: 255
    t.string  "name",           limit: 255
    t.string  "status",         limit: 255
    t.integer "user_id",        limit: 8
  end

  add_index "bank_details", ["user_id"], name: "FK_19hr42ph1kooc82hcj5bdfvm4", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "cat_picture",   limit: 255
    t.string  "name",          limit: 255
    t.integer "order_no",      limit: 4,   default: 0
    t.integer "parent_id",     limit: 4
    t.string  "status",        limit: 255, default: "active"
    t.string  "category_type", limit: 15,  default: "CATEGORY"
    t.string  "old_name",      limit: 255
  end

  create_table "cities", force: :cascade do |t|
    t.string "name",    limit: 255
    t.string "status",  limit: 10,  default: "Active"
    t.binary "popular", limit: 1,   default: "b'0'"
  end

  create_table "collections", force: :cascade do |t|
    t.string  "image",    limit: 255
    t.string  "name",     limit: 255
    t.string  "old_name", limit: 255
    t.integer "order_no", limit: 4,   default: 0
    t.integer "status",   limit: 4,   default: 0
  end

  create_table "deliveries_mode", force: :cascade do |t|
    t.string "created_at", limit: 255
    t.string "mode",       limit: 255
    t.string "status",     limit: 255
  end

  create_table "devices", force: :cascade do |t|
    t.string   "app_version", limit: 255
    t.datetime "login_at",                null: false
    t.datetime "logout_at",               null: false
    t.string   "os",          limit: 255
    t.string   "os_version",  limit: 255
    t.integer  "otp",         limit: 4,   null: false
    t.string   "push_id",     limit: 255
    t.string   "size",        limit: 255
    t.string   "uuid",        limit: 255
    t.integer  "user_id",     limit: 8,   null: false
    t.datetime "lastseen_at",             null: false
  end

  add_index "devices", ["user_id"], name: "FK_etpre5tvxqy41kb1d169onaf7", using: :btree
  add_index "devices", ["uuid"], name: "UK_an5hjdvj1me7xnpawemm6gmrv", unique: true, using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer "device_id",  limit: 8, null: false
    t.integer "product_id", limit: 8, null: false
    t.integer "user_id",    limit: 8, null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "user_id",    limit: 100,   null: false
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
  end

  create_table "images", force: :cascade do |t|
    t.boolean "cover_pic",                     default: false
    t.string  "medium",            limit: 255
    t.integer "medium_height",     limit: 4,                      null: false
    t.integer "medium_width",      limit: 4,                      null: false
    t.integer "order_no",          limit: 4,                      null: false
    t.string  "original",          limit: 255
    t.integer "original_height",   limit: 4,                      null: false
    t.integer "original_width",    limit: 4,                      null: false
    t.string  "status",            limit: 10,  default: "Active"
    t.string  "thumb",             limit: 255
    t.integer "thumb_height",      limit: 4,                      null: false
    t.integer "thumb_width",       limit: 4,                      null: false
    t.integer "product_id",        limit: 8
    t.string  "moderation_status", limit: 50
  end

  add_index "images", ["product_id"], name: "FK_jvinkc7xcd0x0pk49c1me6hb6", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "locality",        limit: 255
    t.string  "status",          limit: 11,  default: "Active"
    t.string  "zipcode",         limit: 255
    t.integer "city_id",         limit: 8
    t.string  "google_place_id", limit: 255
  end

  add_index "locations", ["city_id"], name: "FK_6n7ccydyrnxh59q2my43ffb95", using: :btree

  create_table "payment_mode", force: :cascade do |t|
    t.string "created_at", limit: 255
    t.string "mode",       limit: 255
    t.string "status",     limit: 255
  end

  create_table "product_edits", force: :cascade do |t|
    t.float    "applicable_price",   limit: 53
    t.datetime "created_at",                                          null: false
    t.text     "description",        limit: 16777215
    t.float    "latitude",           limit: 53
    t.float    "longitude",          limit: 53
    t.string   "name",               limit: 255,                      null: false
    t.float    "price",              limit: 53
    t.datetime "updated_at",                                          null: false
    t.integer  "user_id",            limit: 8,                        null: false
    t.integer  "category_id",        limit: 8
    t.integer  "location_id",        limit: 8
    t.integer  "parent_category_id", limit: 8
    t.string   "product_condition",  limit: 10
    t.float    "boost_value",        limit: 24
    t.string   "flag_reason",        limit: 255
    t.string   "source",             limit: 50,       default: "APP"
    t.integer  "product_id",         limit: 8
  end

  add_index "product_edits", ["category_id"], name: "FK_category", using: :btree
  add_index "product_edits", ["location_id"], name: "FK_locations", using: :btree
  add_index "product_edits", ["parent_category_id"], name: "FK_parent_category", using: :btree
  add_index "product_edits", ["product_id"], name: "FK_product", using: :btree

  create_table "product_reject_reason", force: :cascade do |t|
    t.integer  "product_id", limit: 8,     null: false
    t.text     "reason",     limit: 65535
    t.datetime "created_at",               null: false
  end

