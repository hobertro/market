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

ActiveRecord::Schema.define(:version => 20140419191151) do

  create_table "comments", :force => true do |t|
    t.integer  "user_listing_id"
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["user_listing_id"], :name => "index_comments_on_user_listing_id"

  create_table "contact_messages", :force => true do |t|
    t.text     "from"
    t.string   "to"
    t.string   "name"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "item_listings", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_listing_id"
    t.integer  "item_id"
    t.string   "status"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "defindex"
    t.string   "item_class"
    t.string   "item_type_name"
    t.text     "item_description"
    t.integer  "item_quality"
    t.text     "image_inventory"
    t.string   "min_ilevel"
    t.string   "max_ilevel"
    t.text     "image_url"
    t.text     "image_url_large"
    t.text     "capabilities"
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
    t.text     "tool"
    t.string   "used_by_classes"
    t.string   "per_class_loadout_slots"
    t.string   "styles"
    t.string   "rarity"
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "messenger_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "user_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "equipped_class"
    t.integer  "equipped_slot"
    t.integer  "quality"
    t.string   "equipped"
    t.string   "name"
    t.string   "defindex"
    t.string   "image_url"
    t.string   "item_description"
    t.string   "item_set"
    t.string   "rarity"
  end

  add_index "user_items", ["item_id"], :name => "index_user_items_on_item_id"
  add_index "user_items", ["user_id"], :name => "index_user_items_on_user_id"

  create_table "user_listings", :force => true do |t|
    t.string   "item_want"
    t.string   "item_have"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "status"
    t.integer  "item_id"
  end

  add_index "user_listings", ["user_id"], :name => "index_user_listings_on_user_id"

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
    t.decimal  "primary_clanid"
    t.integer  "time_created"
    t.integer  "persona_stateflags"
    t.integer  "person_state"
    t.integer  "equipped_class"
    t.integer  "equipped_slot"
    t.integer  "quality"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
