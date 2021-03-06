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

ActiveRecord::Schema.define(version: 20141009005427) do

  create_table "expeditions", force: true do |t|
    t.integer  "user_id"
    t.date     "take_aboard"
    t.date     "delivered"
    t.integer  "region",       default: 1
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount_boxes"
  end

  add_index "expeditions", ["delivered"], name: "index_expeditions_on_delivered", using: :btree
  add_index "expeditions", ["region"], name: "index_expeditions_on_region", using: :btree
  add_index "expeditions", ["take_aboard"], name: "index_expeditions_on_take_aboard", using: :btree
  add_index "expeditions", ["user_id"], name: "index_expeditions_on_user_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "full"
    t.string   "art"
    t.integer  "box"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "technic"
  end

  add_index "items", ["art"], name: "index_items_on_art", using: :btree
  add_index "items", ["name"], name: "index_items_on_name", using: :btree

  create_table "loadups", force: true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "quantity",      default: 0
    t.integer  "q_box",         default: 0
    t.date     "take_aboard"
    t.integer  "region",        default: 1
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expedition_id"
  end

  add_index "loadups", ["expedition_id"], name: "index_loadups_on_expedition_id", using: :btree
  add_index "loadups", ["item_id"], name: "index_loadups_on_item_id", using: :btree
  add_index "loadups", ["region"], name: "index_loadups_on_region", using: :btree
  add_index "loadups", ["take_aboard"], name: "index_loadups_on_take_aboard", using: :btree
  add_index "loadups", ["user_id"], name: "index_loadups_on_user_id", using: :btree

  create_table "lots", force: true do |t|
    t.integer  "item_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lots", ["item_id"], name: "index_lots_on_item_id", using: :btree
  add_index "lots", ["order_id"], name: "index_lots_on_order_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "name"
    t.string   "body"
    t.string   "status"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.date     "deliver_at"
    t.integer  "expeditor"
    t.date     "delivered"
    t.integer  "region",     default: 1
    t.string   "comment"
    t.integer  "q_box"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["deliver_at"], name: "index_orders_on_deliver_at", using: :btree
  add_index "orders", ["delivered"], name: "index_orders_on_delivered", using: :btree
  add_index "orders", ["expeditor"], name: "index_orders_on_expeditor", using: :btree
  add_index "orders", ["region"], name: "index_orders_on_region", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "inspect_id"
    t.date     "data_begin"
    t.date     "data_end"
    t.integer  "q_box",      default: 0
    t.integer  "quantity",   default: 0
    t.string   "status"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sendmen", force: true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.integer  "sender"
    t.string   "status"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slotereports", force: true do |t|
    t.integer  "report_id"
    t.integer  "item_id"
    t.integer  "quantity",   default: 0
    t.integer  "q_box",      default: 0
    t.string   "satatus"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userlogins", force: true do |t|
    t.integer  "user_id",    default: 0
    t.string   "ip_addr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "region",        default: 1
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_owner"
    t.string   "defaults"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["region"], name: "index_users_on_region", using: :btree

end
