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

ActiveRecord::Schema.define(version: 20150813215409) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "core_logic_locations", force: :cascade do |t|
    t.integer  "zip_code"
    t.string   "tier_name"
    t.string   "metrics"
    t.decimal  "active_list_price_mean"
    t.decimal  "active_list_price_median"
    t.integer  "active_listings_dom_mean"
    t.integer  "active_listings_dom_median"
    t.integer  "active_listings_inventory_count"
    t.integer  "sold_inventory_count"
    t.decimal  "sold_list_price_mean"
    t.integer  "sold_listings_dom_mean"
    t.integer  "definition_id"
    t.string   "slug"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "core_logic_locations", ["definition_id"], name: "index_core_logic_locations_on_definition_id", using: :btree
  add_index "core_logic_locations", ["slug"], name: "index_core_logic_locations_on_slug", unique: true, using: :btree

  create_table "definitions", force: :cascade do |t|
    t.string   "name"
    t.string   "class_name"
    t.boolean  "active",        default: false
    t.text     "vgl_header"
    t.text     "vgl_content"
    t.text     "vgl_methods"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "video_type_id"
  end

  add_index "definitions", ["video_type_id"], name: "index_definitions_on_video_type_id", using: :btree

  create_table "find_the_best_locations", force: :cascade do |t|
    t.integer  "ftb_id"
    t.string   "county"
    t.text     "sale_price_intro"
    t.text     "sale_price_verb"
    t.text     "sale_price_change"
    t.text     "sale_price_end"
    t.text     "expected_intro"
    t.text     "expected_change"
    t.text     "expected_months"
    t.text     "list_price_intro"
    t.text     "list_price_change"
    t.text     "list_price_end"
    t.text     "market_text"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "slug"
    t.integer  "definition_id"
  end

  add_index "find_the_best_locations", ["definition_id"], name: "index_find_the_best_locations_on_definition_id", using: :btree
  add_index "find_the_best_locations", ["ftb_id"], name: "index_find_the_best_locations_on_ftb_id", using: :btree
  add_index "find_the_best_locations", ["slug"], name: "index_find_the_best_locations_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_contents", force: :cascade do |t|
    t.string   "uid"
    t.json     "data"
    t.integer  "definition_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "video_contents", ["definition_id"], name: "index_video_contents_on_definition_id", using: :btree
  add_index "video_contents", ["uid"], name: "index_video_contents_on_uid", using: :btree

  create_table "video_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.json     "schema"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "filename"
    t.integer  "duration"
    t.string   "thumbnail_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "videos", ["videoable_id", "videoable_type"], name: "index_videos_on_videoable_id_and_videoable_type", using: :btree

end
