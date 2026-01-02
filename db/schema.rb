# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_02_100448) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "activity_type", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.datetime "email_informed_at"
    t.datetime "email_reminded_at"
    t.integer "email_status", default: 0, null: false
    t.datetime "ends_at", null: false
    t.boolean "notify_residents", default: false, null: false
    t.integer "participants_count"
    t.bigint "residence_id", null: false
    t.text "review"
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["email_status"], name: "index_activities_on_email_status"
    t.index ["residence_id", "status"], name: "index_activities_on_residence_id_and_status"
    t.index ["residence_id"], name: "index_activities_on_residence_id"
    t.index ["starts_at"], name: "index_activities_on_starts_at"
    t.index ["status"], name: "index_activities_on_status"
  end

  create_table "residences", force: :cascade do |t|
    t.text "address", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_residences_on_deleted_at"
  end

  create_table "residents", force: :cascade do |t|
    t.string "apartment"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "notes"
    t.string "phone"
    t.bigint "residence_id", null: false
    t.datetime "updated_at", null: false
    t.index ["residence_id"], name: "index_residents_on_residence_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.datetime "invitation_accepted_at"
    t.datetime "invitation_created_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.string "last_name", null: false
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.bigint "residence_id"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["residence_id"], name: "index_users_on_residence_id"
  end

  add_foreign_key "activities", "residences"
  add_foreign_key "residents", "residences"
  add_foreign_key "users", "residences"
end
