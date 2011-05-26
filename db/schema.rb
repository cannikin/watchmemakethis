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

ActiveRecord::Schema.define(:version => 20110526022323) do

  create_table "allowances", :force => true do |t|
    t.string   "role_id"
    t.string   "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "builds", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "path"
    t.string   "hashtag"
    t.boolean  "archived",      :default => false
    t.boolean  "public",        :default => true
    t.datetime "last_login_at"
    t.integer  "views",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_name"
  end

  add_index "builds", ["hashtag"], :name => "index_builds_on_hashtag"
  add_index "builds", ["path"], :name => "index_builds_on_path"
  add_index "builds", ["site_id"], :name => "index_builds_on_site_id"

  create_table "clients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "build_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["build_id", "user_id"], :name => "index_clients_on_build_id_and_user_id"
  add_index "clients", ["build_id"], :name => "index_clients_on_build_id"
  add_index "clients", ["user_id", "build_id"], :name => "index_clients_on_user_id_and_build_id"
  add_index "clients", ["user_id"], :name => "index_clients_on_user_id"

  create_table "images", :force => true do |t|
    t.integer  "build_id"
    t.string   "filename"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "height"
    t.integer  "width"
    t.string   "tweet_id"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sites", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "path"
    t.boolean  "show_in_directory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "style_id"
  end

  add_index "sites", ["path"], :name => "index_sites_on_path"
  add_index "sites", ["user_id"], :name => "index_sites_on_user_id"

  create_table "styles", :force => true do |t|
    t.string   "header_background"
    t.string   "header_text_color"
    t.string   "body_background"
    t.string   "body_text_color"
    t.string   "image_border"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header_font_family"
    t.string   "header_font_size"
    t.string   "body_font_family"
    t.string   "body_font_size"
    t.boolean  "system",             :default => false
    t.string   "name"
  end

  create_table "systems", :force => true do |t|
    t.string  "twitter_username"
    t.string  "next_twitter_call"
    t.integer "twitpic_count",     :default => 0
    t.integer "yfrog_count",       :default => 0
    t.integer "instagram_count",   :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.string   "twitter"
    t.integer  "role_id"
    t.datetime "last_login_at"
    t.integer  "login_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

end
