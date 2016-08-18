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

ActiveRecord::Schema.define(version: 20160817150342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "booking_access_token_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "booking_access_token_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "booking_access_token_resources", ["booking_access_token_id"], name: "index_booking_access_token_resources_on_booking_access_token_id", using: :btree
  add_index "booking_access_token_resources", ["resource_id"], name: "index_booking_access_token_resources_on_resource_id", using: :btree

  create_table "booking_access_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "discount"
    t.date     "expiry"
    t.date     "signup_expiry"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "user_id"
    t.time     "time_from"
    t.time     "time_to"
    t.string   "stripe_payment_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.date     "book_date"
    t.string   "title"
    t.integer  "charge_cents"
  end

  add_index "bookings", ["resource_id"], name: "index_bookings_on_resource_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

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

  create_table "job_postings", force: :cascade do |t|
    t.string   "description"
    t.integer  "user_id"
    t.string   "title"
    t.date     "expiry"
    t.string   "requirements"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "closed"
  end

  add_index "job_postings", ["user_id"], name: "index_job_postings_on_user_id", using: :btree

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
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "status_email",       default: "memberships@bloom.org.au", null: false
    t.string   "success_email",      default: "memberships@bloom.org.au", null: false
    t.boolean  "wifi_access",        default: false
    t.integer  "free_booking_hours"
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.integer  "pricing_cents"
    t.string   "google_calendar_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "full_name"
    t.string   "group"
    t.integer  "pricing_cents_member"
  end

  create_table "user_booking_access_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "booking_access_token_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_booking_access_tokens", ["booking_access_token_id"], name: "index_user_booking_access_tokens_on_booking_access_token_id", using: :btree
  add_index "user_booking_access_tokens", ["user_id"], name: "index_user_booking_access_tokens_on_user_id", using: :btree

  create_table "user_interests", force: :cascade do |t|
    t.integer  "user_profile_id"
    t.string   "interest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_interests", ["user_profile_id"], name: "index_user_interests_on_user_profile_id", using: :btree

  create_table "user_profiles", force: :cascade do |t|
    t.string   "signup_reason"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "education_status"
    t.string   "university_degree"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "nationality"
    t.string   "user_description"
    t.string   "primary_startup_name"
    t.string   "primary_startup_description"
    t.string   "telephone_number"
    t.string   "university"
    t.string   "university_student_number"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_profile_id"
    t.string   "skill"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_skills", ["user_profile_id"], name: "index_user_skills_on_user_profile_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "stripe_customer_id"
    t.string   "provider"
    t.string   "uid"
    t.integer  "access_level",           default: 0
    t.string   "wifi_password"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "transaction_id"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "booking_access_token_resources", "booking_access_tokens"
  add_foreign_key "booking_access_token_resources", "resources"
  add_foreign_key "bookings", "resources"
  add_foreign_key "bookings", "users"
  add_foreign_key "job_postings", "users"
  add_foreign_key "membership_requests", "membership_types"
  add_foreign_key "membership_requests", "users"
  add_foreign_key "user_booking_access_tokens", "booking_access_tokens"
  add_foreign_key "user_booking_access_tokens", "users"
  add_foreign_key "user_interests", "user_profiles"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "user_skills", "user_profiles"
end
