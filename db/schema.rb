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

ActiveRecord::Schema.define(version: 20170709142931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_deliveries_on_message_id", using: :btree
    t.index ["user_id"], name: "index_deliveries_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.string   "label"
    t.string   "delay"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin_only", default: false, null: false
    t.integer  "team_id"
    t.index ["label"], name: "index_messages_on_label", using: :btree
    t.index ["team_id"], name: "index_messages_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "team_id"
    t.string   "name"
    t.string   "domain"
    t.string   "token"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "slack_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_admin",   default: false, null: false
    t.integer  "team_id"
    t.string   "token"
    t.index ["slack_id"], name: "index_users_on_slack_id", using: :btree
    t.index ["team_id"], name: "index_users_on_team_id", using: :btree
  end

end
