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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140128035632) do

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "defindex"
    t.string   "item_class"
    t.string   "item_type_name"
    t.string   "item_description"
    t.integer  "item_quality"
    t.string   "image_inventory"
    t.string   "min_ilevel"
    t.string   "max_ilevel"
    t.string   "image_url"
    t.string   "image_url_large"
    t.string   "capabilities"
    t.string   "tools"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "item_name"
    t.string   "proper_name"
    t.string   "item_slot"
    t.string   "drop_type"
    t.string   "item_set"
    t.string   "holiday_restrictions"
    t.string   "model_player"
    t.string   "craft_class"
    t.string   "craft_material_type"
    t.string   "attributes"
    t.string   "tool"
    t.string   "used_by_classes"
    t.string   "per_class_loadout_slots"
    t.string   "styles"
  end

  create_table "user_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_items", ["item_id"], :name => "index_user_items_on_item_id"
  add_index "user_items", ["user_id"], :name => "index_user_items_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "steam_name"
    t.string   "steam_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "remember_token"
    t.integer  "community_visibility"
    t.integer  "profile_state"
    t.integer  "last_logoff"
    t.string   "profile_url"
    t.string   "avatar"
    t.string   "avatar_medium"
    t.string   "avatar_full"
    t.integer  "primary_clanid"
    t.integer  "time_created"
    t.integer  "persona_stateflags"
    t.integer  "person_state"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
