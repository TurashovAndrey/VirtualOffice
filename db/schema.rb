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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120727145920) do

  create_table "attachments", :force => true do |t|
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.integer  "user_id"
    t.integer  "folder_id"
  end

  create_table "calendars", :force => true do |t|
    t.string   "calendar_name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "comment"
    t.datetime "comment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stage_id"
    t.integer  "project_id"
    t.integer  "discussion_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",              :default => "",           :null => false
    t.string   "url_base",          :default => "",           :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.date     "expire_date",       :default => '2099-01-01'
    t.integer  "default_group"
    t.integer  "calendar_id"
  end

  create_table "conferences", :force => true do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "owner_id"
  end

  create_table "discussions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "theme_id"
    t.string   "discussion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "calendar_id"
  end

  create_table "folders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "folder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "group_name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "company_id"
    t.integer  "folder_id"
    t.integer  "calendar_id"
    t.integer  "theme_id"
    t.integer  "stage_id"
    t.integer  "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "project_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "company_id"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.string   "session_id"
    t.boolean  "public"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "stages", :force => true do |t|
    t.string   "stage_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id"
    t.integer  "task_attachment_id"
    t.integer  "project_id"
  end

  create_table "task_attachments", :force => true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "comment_id"
    t.integer  "project_id"
    t.integer  "stage_id"
    t.integer  "discussion_id"
  end

  create_table "tasks", :force => true do |t|
    t.boolean  "done"
    t.string   "title"
    t.text     "notes"
    t.integer  "priority"
    t.date     "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "second_user_id"
    t.integer  "company_id"
    t.datetime "task_date"
    t.integer  "project_id"
    t.integer  "stage_id"
  end

  create_table "themes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                  :null => false
    t.string   "company_id"
    t.integer  "role_id"
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "active",              :default => false, :null => false
    t.string   "telephone"
    t.string   "address"
    t.integer  "group_id"
    t.boolean  "set_chat",            :default => false
  end

end
