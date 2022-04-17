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

ActiveRecord::Schema[7.0].define(version: 2022_02_14_005201) do
  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_id", null: false
    t.index ["users_id"], name: "index_admins_on_users_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "weekday_one"
    t.string "weekday_two"
    t.string "start_time"
    t.string "end_time"
    t.string "code"
    t.integer "capacity"
    t.integer "available_capacity"
    t.integer "waitlist_capacity"
    t.integer "avaialable_waitlist_capacity"
    t.string "room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instructors_id", null: false
    t.integer "statuses_id", null: false
    t.index ["instructors_id"], name: "index_courses_on_instructors_id"
    t.index ["statuses_id"], name: "index_courses_on_statuses_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.string "status"
    t.integer "waitlist_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "courses_id", null: false
    t.integer "students_id", null: false
    t.index ["courses_id"], name: "index_enrollments_on_courses_id"
    t.index ["students_id"], name: "index_enrollments_on_students_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_id", null: false
    t.index ["users_id"], name: "index_instructors_on_users_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "status_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.date "date_of_birth"
    t.string "phone_number"
    t.string "major"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_id", null: false
    t.index ["users_id"], name: "index_students_on_users_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "primary_user"
    t.integer "privilege"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admins", "users", column: "users_id"
  add_foreign_key "courses", "instructors", column: "instructors_id"
  add_foreign_key "courses", "statuses", column: "statuses_id"
  add_foreign_key "enrollments", "courses", column: "courses_id"
  add_foreign_key "enrollments", "students", column: "students_id"
  add_foreign_key "instructors", "users", column: "users_id"
  add_foreign_key "students", "users", column: "users_id"
end
