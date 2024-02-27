# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_02_170841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ussd_sessions", force: :cascade do |t|
    t.string "session_id"
    t.string "ussd_trnx_id"
    t.string "msisdn"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "status", default: 1
    t.string "ussd_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_ussd_sessions_on_session_id", unique: true
  end

end
