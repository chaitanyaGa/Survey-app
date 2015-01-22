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

ActiveRecord::Schema.define(version: 20150122031425) do

  create_table "options", force: :cascade do |t|
    t.string   "options",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "questions_id", null: false
  end

  add_index "options", ["questions_id"], name: "index_options_on_questions_id"

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "surveys_id", null: false
  end

  add_index "questions", ["surveys_id"], name: "index_questions_on_surveys_id"

  create_table "responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "options_id", null: false
    t.integer  "users_id",   null: false
  end

  add_index "responses", ["options_id"], name: "index_responses_on_options_id"
  add_index "responses", ["users_id"], name: "index_responses_on_users_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.date     "conducted"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "no_of_peaople"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "age"
    t.string   "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "roles_id",   null: false
  end

end
