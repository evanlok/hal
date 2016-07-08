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

ActiveRecord::Schema.define(version: 20160708224612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "global_scene_attributes", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.text     "description"
    t.integer  "scene_attribute_type_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "scene_attribute_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scene_attributes", force: :cascade do |t|
    t.integer  "scene_id"
    t.integer  "scene_attribute_type_id"
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "position"
    t.text     "description"
  end

  add_index "scene_attributes", ["scene_attribute_type_id"], name: "index_scene_attributes_on_scene_attribute_type_id", using: :btree
  add_index "scene_attributes", ["scene_id", "name"], name: "index_scene_attributes_on_scene_id_and_name", unique: true, using: :btree

  create_table "scene_collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb    "data"
  end

  create_table "scene_global_scene_attributes", force: :cascade do |t|
    t.integer  "scene_id"
    t.integer  "global_scene_attribute_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "scene_global_scene_attributes", ["global_scene_attribute_id"], name: "global_scene_attribute_id_index", using: :btree
  add_index "scene_global_scene_attributes", ["scene_id", "global_scene_attribute_id"], name: "scene_id_global_scene_attribute_id_index", unique: true, using: :btree

  create_table "scenes", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",      default: false
    t.text     "vgl_content"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "width"
    t.integer  "height"
    t.integer  "duration"
    t.string   "background"
  end

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

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "video_contents", force: :cascade do |t|
    t.string   "uid"
    t.jsonb    "data"
    t.integer  "definition_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "callback_url"
  end

  add_index "video_contents", ["definition_id"], name: "index_video_contents_on_definition_id", using: :btree
  add_index "video_contents", ["uid"], name: "index_video_contents_on_uid", using: :btree

  create_table "video_previews", force: :cascade do |t|
    t.integer  "previewable_id"
    t.string   "previewable_type"
    t.text     "stream_url"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "callback_url"
  end

  add_index "video_previews", ["previewable_id", "previewable_type"], name: "index_video_previews_on_previewable_id_and_previewable_type", using: :btree

  create_table "video_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.jsonb    "schema"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "videos", force: :cascade do |t|
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "filename"
    t.integer  "duration"
    t.string   "thumbnail_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "stream_url"
    t.text     "callback_url"
    t.text     "stream_callback_url"
    t.jsonb    "resolutions"
  end

  add_index "videos", ["videoable_id", "videoable_type"], name: "index_videos_on_videoable_id_and_videoable_type", using: :btree

end
