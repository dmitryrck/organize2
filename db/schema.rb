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

ActiveRecord::Schema.define(version: 20161009004744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.decimal  "start_balance", default: 0.0
    t.decimal  "balance",       default: 0.0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
  end

  create_table "cards", force: :cascade do |t|
    t.string   "name"
    t.decimal  "limit",       default: 0.0
    t.integer  "payment_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "movements", force: :cascade do |t|
    t.string   "description"
    t.decimal  "value"
    t.boolean  "paid",                                       default: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "kind"
    t.date     "paid_at"
    t.string   "category"
    t.integer  "chargeable_id"
    t.string   "chargeable_type"
    t.integer  "parent_id"
    t.integer  "card_id"
    t.decimal  "fee",              precision: 15, scale: 10, default: 0.0
    t.string   "fee_kind"
    t.string   "transaction_hash"
  end

  add_index "movements", ["card_id"], name: "index_movements_on_card_id", using: :btree
  add_index "movements", ["chargeable_id"], name: "index_movements_on_chargeable_id", using: :btree
  add_index "movements", ["paid"], name: "index_movements_on_paid", using: :btree
  add_index "movements", ["paid_at"], name: "index_movements_on_paid_at", using: :btree
  add_index "movements", ["parent_id"], name: "index_movements_on_parent_id", using: :btree
  add_index "movements", ["transaction_hash", "chargeable_type", "chargeable_id"], name: "index_movements_on_transaction_hash", unique: true, using: :btree

  create_table "trades", force: :cascade do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.decimal  "value_in",         default: 0.0
    t.decimal  "value_out",        default: 0.0
    t.decimal  "fee",              default: 0.0
    t.date     "trade_at"
    t.string   "transaction_hash"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "confirmed",        default: false
  end

  add_index "trades", ["destination_id"], name: "index_trades_on_destination_id", using: :btree
  add_index "trades", ["source_id"], name: "index_trades_on_source_id", using: :btree
  add_index "trades", ["transaction_hash"], name: "index_trades_on_transaction_hash", unique: true, using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "source_id"
    t.integer  "destination_id"
    t.decimal  "value"
    t.boolean  "transfered",       default: false
    t.date     "transfered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_hash"
  end

  add_index "transfers", ["transaction_hash"], name: "index_transfers_on_transaction_hash", unique: true, using: :btree

  add_foreign_key "movements", "cards"
  add_foreign_key "movements", "movements", column: "parent_id"
  add_foreign_key "trades", "accounts", column: "destination_id"
  add_foreign_key "trades", "accounts", column: "source_id"
end
