# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100120011303) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.boolean  "accept"
    t.datetime "created_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "category_id",                        :null => false
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.string   "country"
    t.string   "city"
    t.datetime "time"
    t.boolean  "active"
    t.string   "timezone"
    t.datetime "created_at"
    t.integer  "view_count"
    t.boolean  "flag_inappro",    :default => false
    t.text     "inappro_comment"
    t.string   "tagged_by"
    t.text     "extra_detail"
  end

  create_table "invite_friends", :force => true do |t|
    t.string   "email",                      :null => false
    t.integer  "user_id",                    :null => false
    t.integer  "join_status", :default => 0
    t.datetime "created_at"
    t.string   "name"
    t.text     "mailtext"
  end

  create_table "invites", :force => true do |t|
    t.string   "email",                      :null => false
    t.integer  "user_id",                    :null => false
    t.integer  "join_status", :default => 0
    t.string   "name"
    t.text     "mailtext"
    t.datetime "created_at"
  end

  create_table "mains", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.boolean  "accept"
    t.datetime "created_at"
    t.text     "response"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "display_name",   :limit => 50,                                  :null => false
    t.string   "email",                                                         :null => false
    t.date     "dob"
    t.string   "gender",         :limit => 2
    t.string   "mobile"
    t.boolean  "mobile_auth"
    t.boolean  "email_auth"
    t.string   "password",                                                      :null => false
    t.text     "about"
    t.text     "interests"
    t.datetime "created_at"
    t.text     "extra"
    t.string   "content_type",                         :default => "image/png"
    t.binary   "picture",        :limit => 2147483647
    t.integer  "view_count"
    t.string   "auth_code"
    t.text     "mail_fail"
    t.boolean  "mail_news"
    t.text     "login_ip"
    t.boolean  "accepted_terms"
    t.string   "reset_code"
  end

  create_table "wallentries", :force => true do |t|
    t.text     "entry_text", :null => false
    t.integer  "event_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
  end

end
