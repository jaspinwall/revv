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

ActiveRecord::Schema.define(version: 20170221233242) do

  create_table "buyers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["user_id"], name: "index_buyers_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "purchase_id"
    t.string   "source"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "stripe_response"
    t.integer  "application_fee_cents"
    t.index ["purchase_id"], name: "index_charges_on_purchase_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "seller_id"
    t.string   "name"
    t.integer  "price_cents"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "lock_version"
    t.index ["seller_id"], name: "index_products_on_seller_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "buyer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["product_id"], name: "index_purchases_on_product_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "publishable_key"
    t.string   "secret_key"
    t.string   "stripe_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.index ["user_id"], name: "index_sellers_on_user_id"
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
