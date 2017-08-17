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

ActiveRecord::Schema.define(version: 20170815225827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "start_balance", default: "0.0"
    t.decimal "balance", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.string "currency"
    t.integer "precision", default: 2
    t.index ["currency"], name: "index_accounts_on_currency"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cards", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "limit", default: "0.0"
    t.integer "payment_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "active", default: true
    t.integer "precision", default: 2
  end

  create_table "movements", id: :serial, force: :cascade do |t|
    t.string "description"
    t.decimal "value"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.date "paid_at"
    t.string "category"
    t.integer "chargeable_id"
    t.string "chargeable_type"
    t.integer "parent_id"
    t.integer "card_id"
    t.decimal "fee", precision: 15, scale: 10, default: "0.0"
    t.string "fee_kind"
    t.string "transaction_hash"
    t.index ["card_id"], name: "index_movements_on_card_id"
    t.index ["chargeable_id"], name: "index_movements_on_chargeable_id"
    t.index ["description"], name: "index_movements_on_description"
    t.index ["paid"], name: "index_movements_on_paid"
    t.index ["paid_at"], name: "index_movements_on_paid_at"
    t.index ["parent_id"], name: "index_movements_on_parent_id"
    t.index ["transaction_hash", "chargeable_type", "chargeable_id"], name: "index_movements_on_transaction_hash", unique: true
  end

  create_table "trades", id: :serial, force: :cascade do |t|
    t.integer "source_id"
    t.integer "destination_id"
    t.decimal "value_in", default: "0.0"
    t.decimal "value_out", default: "0.0"
    t.decimal "fee", default: "0.0"
    t.date "trade_at"
    t.string "transaction_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.string "kind"
    t.index ["destination_id"], name: "index_trades_on_destination_id"
    t.index ["source_id"], name: "index_trades_on_source_id"
    t.index ["transaction_hash"], name: "index_trades_on_transaction_hash", unique: true
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "source_id"
    t.integer "destination_id"
    t.decimal "value"
    t.boolean "confirmed", default: false
    t.date "transfered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "transaction_hash"
    t.decimal "fee", default: "0.0"
    t.index ["transaction_hash"], name: "index_transfers_on_transaction_hash", unique: true
  end

  add_foreign_key "movements", "cards"
  add_foreign_key "movements", "movements", column: "parent_id"
  add_foreign_key "trades", "accounts", column: "destination_id"
  add_foreign_key "trades", "accounts", column: "source_id"
end
