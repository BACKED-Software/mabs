# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_240_305_021_214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'announcements', primary_key: 'announcementID', force: :cascade do |t|
    t.string 'googleUserID'
    t.text 'subject'
    t.datetime 'dateOfAnnouncement'
    t.text 'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'events', force: :cascade do |t|
    t.text 'eventLocation'
    t.text 'eventInfo'
    t.string 'eventName'
    t.datetime 'eventTime'
    t.integer 'eventPoints'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'sponsor_title'
    t.text 'sponsor_description'
  end
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

ActiveRecord::Schema[7.0].define(version: 20_240_228_065_858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", primary_key: "announcementID", force: :cascade do |t|
    t.string "googleUserID"
    t.text "subject"
    t.datetime "dateOfAnnouncement"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "eventID"
    t.text "googleUserID"
    t.datetime "timeOfCheckIn"
    t.integer "pointsAwarded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.text "eventLocation"
    t.text "eventInfo"
    t.string "eventName"
    t.datetime "eventTime"
    t.integer "eventPoints"
    t.integer 'eventPoints'
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sponsor_title"
    t.text "sponsor_description"
    t.string "password"
  end

  create_table 'points', force: :cascade do |t|
    t.integer 'numPointsAwarded'
    t.string 'awardedBy'
    t.string 'awardedTo'
    t.datetime 'dateOfAward'
    t.text 'awardDescription'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'rsvps', force: :cascade do |t|
    t.string 'user_uid'
    t.bigint 'event_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['event_id'], name: 'index_rsvps_on_event_id'
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "email", null: false
    t.boolean "is_admin", default: false
    t.string "full_name"
    t.string "middle_initial", limit: 1
    t.string "gender"
    t.boolean "is_hispanic_or_latino"
    t.string "race"
    t.boolean "is_us_citizen"
    t.boolean "is_first_generation_college_student"
    t.datetime "date_of_birth"
    t.string "phone_number"
    t.string "avatar_url"
    t.text "bio"
    t.string "classification"
    t.integer "total_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer 'role'
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "announcements", "users", column: "googleUserID", primary_key: "uid"
  add_foreign_key "attendances", "events", column: "eventID"
  add_foreign_key "attendances", "users", column: "googleUserID", primary_key: "uid"
  add_foreign_key 'rsvps', 'events'
  add_foreign_key 'rsvps', 'users', column: 'user_uid', primary_key: 'uid', on_delete: :cascade
end
