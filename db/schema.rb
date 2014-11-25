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

ActiveRecord::Schema.define(version: 20141124235250) do

  create_table "addresses", force: true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["city"], name: "index_addresses_on_city"
  add_index "addresses", ["state"], name: "index_addresses_on_state"

  create_table "rides", force: true do |t|
    t.string   "type"
    t.string   "origin"
    t.string   "destination"
    t.string   "total_seat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "business_name"
    t.string   "business_email"
    t.boolean  "verified_business_email", default: false, null: false
    t.integer  "user_id"
    t.string   "origin_address"
    t.string   "destination_address"
    t.string   "commute_days"
  end

  add_index "rides", ["destination"], name: "index_rides_on_destination"
  add_index "rides", ["origin", "destination"], name: "index_rides_on_origin_and_destination"
  add_index "rides", ["origin"], name: "index_rides_on_origin"
  add_index "rides", ["user_id"], name: "index_rides_on_user_id"

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
