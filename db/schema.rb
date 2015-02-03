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

ActiveRecord::Schema.define(version: 20150121042828) do

  create_table "book_genres", force: true do |t|
    t.integer  "project_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_genres", ["genre_id"], name: "index_book_genres_on_genre_id"
  add_index "book_genres", ["project_id"], name: "index_book_genres_on_project_id"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id", "created_at"], name: "index_comments_on_post_id_and_created_at"
  add_index "comments", ["post_id", "user_id", "created_at"], name: "index_comments_on_post_id_and_user_id_and_created_at", unique: true
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "current_tasks", force: true do |t|
    t.integer  "project_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_tasks", ["project_id", "task_id"], name: "index_current_tasks_on_project_id_and_task_id", unique: true
  add_index "current_tasks", ["project_id"], name: "index_current_tasks_on_project_id"
  add_index "current_tasks", ["task_id"], name: "index_current_tasks_on_task_id"

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phases", force: true do |t|
    t.integer  "project_view_id"
    t.string   "name"
    t.string   "color"
    t.string   "color_value"
    t.string   "icon"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phases", ["project_view_id"], name: "index_phases_on_project_view_id"

  create_table "post_tags", force: true do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_tags", ["post_id", "tag_id"], name: "index_post_tags_on_post_id_and_tag_id", unique: true

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "post_date"
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "featured_image_file_name"
    t.string   "featured_image_content_type"
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
  end

  add_index "posts", ["post_date", "title", "author_id"], name: "index_posts_on_post_date_and_title_and_author_id"
  add_index "posts", ["post_date", "title"], name: "index_posts_on_post_date_and_title"

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "project_type_workflows", force: true do |t|
    t.integer  "workflow_id"
    t.integer  "project_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_type_workflows", ["project_type_id"], name: "index_project_type_workflows_on_project_type_id"
  add_index "project_type_workflows", ["workflow_id", "project_type_id"], name: "index_ptws_on_workflow_id_project_type_id"
  add_index "project_type_workflows", ["workflow_id"], name: "index_project_type_workflows_on_workflow_id"

  create_table "project_types", force: true do |t|
    t.string   "name"
    t.float    "team_total_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_views", force: true do |t|
    t.integer  "project_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_views", ["project_type_id"], name: "index_project_views_on_project_type_id"

  create_table "projects", force: true do |t|
    t.integer  "final_doc_file"
    t.integer  "final_manuscript_pdf"
    t.integer  "final_pdf"
    t.string   "stock_image_request_link"
    t.text     "layout_notes"
    t.boolean  "previously_published"
    t.string   "prev_publisher_and_date"
    t.integer  "stock_cover_image"
    t.text     "cover_concept_notes"
    t.float    "proofed_word_count"
    t.integer  "cover_concept"
    t.string   "teamroom_link"
    t.integer  "final_mobi"
    t.datetime "publication_date"
    t.integer  "final_epub"
    t.datetime "marketing_release_date"
    t.string   "paperback_cover_type"
    t.string   "age_range"
    t.text     "search_terms"
    t.string   "bisac_code_3"
    t.string   "bisac_code_2"
    t.string   "bisac_code_1"
    t.float    "ebook_price"
    t.float    "print_price"
    t.string   "blurb_one_line"
    t.text     "endorsements"
    t.text     "author_bio"
    t.text     "blurb_description"
    t.string   "final_title"
    t.datetime "cover_art_approval_date"
    t.integer  "alternative_cover_template"
    t.integer  "createspace_cover"
    t.integer  "lightning_source_cover"
    t.integer  "ebook_front_cover"
    t.datetime "layout_approved_date"
    t.float    "final_page_count"
    t.integer  "layout_upload"
    t.boolean  "use_pen_name_on_title"
    t.boolean  "use_pen_name_for_copyright"
    t.string   "exact_name_on_copyright"
    t.string   "pen_name"
    t.text     "special_text_treatment"
    t.boolean  "has_sub_chapters"
    t.string   "layout_style_choice"
    t.boolean  "has_index"
    t.boolean  "non_standard_size"
    t.boolean  "has_internal_illustrations"
    t.boolean  "color_interior"
    t.integer  "manuscript_edited"
    t.boolean  "childrens_book"
    t.integer  "manuscript_proofed"
    t.datetime "edit_complete_date"
    t.integer  "manuscript_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_type_id"
  end

  add_index "projects", ["project_type_id"], name: "index_projects_on_project_type_id"

  create_table "required_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "project_type_id"
    t.float    "suggested_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "required_roles", ["project_type_id"], name: "index_required_roles_on_project_type_id"
  add_index "required_roles", ["role_id"], name: "index_required_roles_on_role_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: true do |t|
    t.string   "form_name"
    t.datetime "date"
    t.float    "project_id"
    t.float    "user_id"
    t.float    "entry_id"
    t.string   "process_step"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabs", force: true do |t|
    t.integer  "task_id"
    t.integer  "phase_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tabs", ["phase_id"], name: "index_tabs_on_phase_id"
  add_index "tabs", ["task_id"], name: "index_tabs_on_task_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["id", "name"], name: "index_tags_on_id_and_name"
  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "task_performers", force: true do |t|
    t.integer  "task_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_performers", ["role_id"], name: "index_task_performers_on_role_id"
  add_index "task_performers", ["task_id"], name: "index_task_performers_on_task_id"

  create_table "task_prerequisite_fields", force: true do |t|
    t.integer  "task_id"
    t.string   "field_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_prerequisite_fields", ["task_id"], name: "index_task_prerequisite_fields_on_task_id"

  create_table "tasks", force: true do |t|
    t.integer  "workflow_id"
    t.integer  "next_id"
    t.integer  "rejected_task_id"
    t.string   "partial"
    t.string   "name"
    t.string   "icon"
    t.string   "tab_text"
    t.string   "intro_video"
    t.integer  "days_to_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["next_id"], name: "index_tasks_on_next_id"
  add_index "tasks", ["rejected_task_id"], name: "index_tasks_on_rejected_task_id"
  add_index "tasks", ["workflow_id"], name: "index_tasks_on_workflow_id"

  create_table "team_memberships", force: true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.integer  "role_id"
    t.float    "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_memberships", ["member_id"], name: "index_team_memberships_on_member_id"
  add_index "team_memberships", ["project_id", "member_id", "role_id"], name: "index_team_memberships_on_project_id_and_member_id_and_role_id"
  add_index "team_memberships", ["project_id"], name: "index_team_memberships_on_project_id"
  add_index "team_memberships", ["role_id"], name: "index_team_memberships_on_role_id"

  create_table "unlocked_tasks", force: true do |t|
    t.integer  "task_id"
    t.integer  "unlocked_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unlocked_tasks", ["task_id"], name: "index_unlocked_tasks_on_task_id"
  add_index "unlocked_tasks", ["unlocked_task_id"], name: "index_unlocked_tasks_on_unlocked_task_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "workflows", force: true do |t|
    t.string   "name"
    t.integer  "root_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workflows", ["root_task_id"], name: "index_workflows_on_root_task_id"

end
