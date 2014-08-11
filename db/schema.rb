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

ActiveRecord::Schema.define(version: 20140717095451) do

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colonies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", force: true do |t|
    t.decimal  "amount",     precision: 10, scale: 2
    t.string   "source"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_locations", force: true do |t|
    t.string   "name"
    t.datetime "delivery_timing"
    t.integer  "colony_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "sku"
    t.decimal  "price",              precision: 10, scale: 2
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "category_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items_menus", force: true do |t|
    t.integer  "item_id"
    t.integer  "menu_id"
    t.datetime "availability_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "item_type"
  end

  create_table "line_items", force: true do |t|
    t.integer  "main_id"
    t.integer  "side_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id"

  create_table "locations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.string   "title"
    t.date     "available_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",       default: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "main_id"
    t.integer  "side_id"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount",        precision: 10, scale: 2
    t.datetime "delivery_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "items"
    t.boolean  "redeemed",                               default: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "password_digest"
    t.boolean  "is_admin",                                        default: false
    t.decimal  "total_credits",          precision: 10, scale: 2, default: 0.0
    t.decimal  "availed_credits",        precision: 10, scale: 2, default: 0.0
    t.string   "auth_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "colony_id"
    t.string   "encrypted_password",                              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "remember_token"
  end

  add_index "users", ["colony_id"], name: "index_users_on_colony_id"
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
