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

ActiveRecord::Schema[7.2].define(version: 2025_09_06_091040) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collection_snippets", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "snippet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "snippet_id"], name: "index_collection_snippets_on_collection_id_and_snippet_id", unique: true
    t.index ["collection_id"], name: "index_collection_snippets_on_collection_id"
    t.index ["snippet_id"], name: "index_collection_snippets_on_snippet_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "visibility"
    t.bigint "user_id", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_collections_on_slug", unique: true
    t.index ["user_id"], name: "index_collections_on_user_id"
    t.index ["visibility"], name: "index_collections_on_visibility"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "snippet_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snippet_id", "created_at"], name: "index_comments_on_snippet_id_and_created_at"
    t.index ["snippet_id"], name: "index_comments_on_snippet_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "edit_requests", force: :cascade do |t|
    t.bigint "snippet_id", null: false
    t.bigint "requester_id", null: false
    t.bigint "approver_id"
    t.string "status", default: "pending", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_edit_requests_on_approver_id"
    t.index ["requester_id"], name: "index_edit_requests_on_requester_id"
    t.index ["snippet_id", "requester_id"], name: "index_edit_requests_on_snippet_id_and_requester_id", unique: true
    t.index ["snippet_id"], name: "index_edit_requests_on_snippet_id"
    t.index ["status"], name: "index_edit_requests_on_status"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "email_comments"
    t.boolean "email_stars"
    t.boolean "email_views"
    t.boolean "email_copies"
    t.boolean "push_comments"
    t.boolean "push_stars"
    t.boolean "push_views"
    t.boolean "push_copies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "actor_type", null: false
    t.bigint "actor_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "action"
    t.datetime "read_at"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "snippet_tags", force: :cascade do |t|
    t.bigint "snippet_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snippet_id", "tag_id"], name: "index_snippet_tags_on_snippet_id_and_tag_id", unique: true
    t.index ["snippet_id"], name: "index_snippet_tags_on_snippet_id"
    t.index ["tag_id"], name: "index_snippet_tags_on_tag_id"
  end

  create_table "snippets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.text "code"
    t.string "language"
    t.integer "visibility"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "view_count", default: 0, null: false
    t.integer "copy_count", default: 0, null: false
    t.index ["copy_count"], name: "index_snippets_on_copy_count"
    t.index ["created_at"], name: "index_snippets_on_created_at"
    t.index ["language"], name: "index_snippets_on_language"
    t.index ["slug"], name: "index_snippets_on_slug", unique: true
    t.index ["user_id"], name: "index_snippets_on_user_id"
    t.index ["view_count"], name: "index_snippets_on_view_count"
    t.index ["visibility"], name: "index_snippets_on_visibility"
  end

  create_table "stack_snippets", force: :cascade do |t|
    t.bigint "stack_id", null: false
    t.bigint "snippet_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snippet_id"], name: "index_stack_snippets_on_snippet_id"
    t.index ["stack_id"], name: "index_stack_snippets_on_stack_id"
  end

  create_table "stacks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.integer "visibility"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_stacks_on_slug", unique: true
    t.index ["user_id"], name: "index_stacks_on_user_id"
  end

  create_table "stars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "snippet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snippet_id"], name: "index_stars_on_snippet_id"
    t.index ["user_id", "snippet_id"], name: "index_stars_on_user_id_and_snippet_id", unique: true
    t.index ["user_id"], name: "index_stars_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_tags_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "name"
    t.text "bio"
    t.string "avatar"
    t.string "slug"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "collection_snippets", "collections"
  add_foreign_key "collection_snippets", "snippets"
  add_foreign_key "collections", "users"
  add_foreign_key "comments", "snippets"
  add_foreign_key "comments", "users"
  add_foreign_key "edit_requests", "snippets"
  add_foreign_key "edit_requests", "users", column: "approver_id"
  add_foreign_key "edit_requests", "users", column: "requester_id"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "snippet_tags", "snippets"
  add_foreign_key "snippet_tags", "tags"
  add_foreign_key "snippets", "users"
  add_foreign_key "stack_snippets", "snippets"
  add_foreign_key "stack_snippets", "stacks"
  add_foreign_key "stacks", "users"
  add_foreign_key "stars", "snippets"
  add_foreign_key "stars", "users"
  add_foreign_key "tags", "users"
end
