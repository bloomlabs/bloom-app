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

ActiveRecord::Schema.define(version: 20160307040949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "membership_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "membership_type_id"
    t.date     "startdate"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "workflow_state"
    t.boolean  "closed",                 default: false
    t.text     "info"
    t.string   "stripe_subscription_id"
    t.text     "interview_book_info"
    t.text     "cancel_reason"
  end

  add_index "membership_requests", ["membership_type_id"], name: "index_membership_requests_on_membership_type_id", using: :btree
  add_index "membership_requests", ["user_id"], name: "index_membership_requests_on_user_id", using: :btree

  create_table "membership_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "stripe_id"
    t.boolean  "recurring"
    t.boolean  "autoapprove"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "status_email",  default: "memberships@bloom.org.au", null: false
    t.string   "success_email", default: "memberships@bloom.org.au", null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string   "signup_reason"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "education_status"
    t.string   "university_degree"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "nationality"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

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
    t.string   "stripe_customer_id"
    t.string   "provider"
    t.string   "uid"
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

  add_foreign_key "membership_requests", "membership_types"
  add_foreign_key "membership_requests", "users"
  add_foreign_key "user_profiles", "users"
end
