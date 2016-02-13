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

ActiveRecord::Schema.define(version: 20160213143229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "state_id"
    t.integer  "membership_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "start_date"
  end

  add_index "applications", ["membership_id"], name: "index_applications_on_membership_id", using: :btree
  add_index "applications", ["state_id"], name: "index_applications_on_state_id", using: :btree
  add_index "applications", ["user_id"], name: "index_applications_on_user_id", using: :btree

  create_table "membership_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "startdate"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "workflow_state"
    t.integer  "membership_type_id"
    t.boolean  "closed",             default: false
  end

  add_index "membership_requests", ["membership_type_id"], name: "index_membership_requests_on_membership_type_id", using: :btree
  add_index "membership_requests", ["user_id"], name: "index_membership_requests_on_user_id", using: :btree

  create_table "membership_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "stripe_id"
    t.boolean  "recurring"
    t.boolean  "autoapprove"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.boolean  "recurring"
    t.text     "expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "staff",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "applications", "memberships"
  add_foreign_key "applications", "states"
  add_foreign_key "applications", "users"
  add_foreign_key "membership_requests", "membership_types"
  add_foreign_key "membership_requests", "users"
end
