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

ActiveRecord::Schema.define(version: 20150107115029) do

  create_table "tags", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "userpages", force: true do |t|
    t.string   "filename"
    t.string   "linkname"
    t.integer  "seqno"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "userpages", ["filename"], name: "index_userpages_on_filename"

end
