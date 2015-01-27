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

ActiveRecord::Schema.define(version: 20150127124937) do

  create_table "options", force: :cascade do |t|
    t.string   "options",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "question_id", null: false
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id"

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "survey_id",  null: false
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id"

  create_table "responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "option_id",  null: false
    t.integer  "user_id",    null: false
  end

  add_index "responses", ["option_id"], name: "index_responses_on_option_id"
  add_index "responses", ["user_id"], name: "index_responses_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.string   "type_of_survey"
    t.date     "conducted"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "no_of_people"
    t.integer  "question_count"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "age"
    t.string   "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "role_id"
  end

end
