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

ActiveRecord::Schema.define(version: 20150504205726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "artwork_rights_requests", force: true do |t|
    t.integer  "project_id"
    t.string   "role_type"
    t.string   "full_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artwork_rights_requests", ["project_id"], name: "index_artwork_rights_requests_on_project_id", using: :btree

  create_table "audit_team_membership_removals", force: true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.integer  "role_id"
    t.float    "percentage"
    t.string   "reason"
    t.text     "notes"
    t.boolean  "notified_member"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audit_team_membership_removals", ["project_id"], name: "index_audit_team_membership_removals_on_project_id", using: :btree

  create_table "blog_tours", force: true do |t|
    t.integer  "project_id"
    t.float    "cost"
    t.string   "tour_type"
    t.string   "blog_tour_service"
    t.integer  "number_of_stops"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_tours", ["project_id"], name: "index_blog_tours_on_project_id", using: :btree

  create_table "book_genres", force: true do |t|
    t.integer  "project_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_genres", ["genre_id"], name: "index_book_genres_on_genre_id", using: :btree
  add_index "book_genres", ["project_id"], name: "index_book_genres_on_project_id", using: :btree

  create_table "box_credentials", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "anti_forgery_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "box_credentials", ["anti_forgery_token"], name: "index_box_credentials_on_anti_forgery_token", unique: true, using: :btree

  create_table "control_numbers", force: true do |t|
    t.integer  "project_id"
    t.string   "imprint"
    t.float    "ebook_library_price"
    t.string   "asin"
    t.string   "apple_id"
    t.string   "epub_isbn"
    t.string   "hardback_isbn"
    t.string   "paperback_isbn"
    t.string   "parse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "control_numbers", ["project_id"], name: "index_control_numbers_on_project_id", using: :btree

  create_table "cover_concepts", force: true do |t|
    t.integer  "project_id"
    t.text     "cover_concept_notes"
    t.date     "cover_art_approval_date"
    t.string   "cover_concept_file_name"
    t.string   "cover_concept_content_type"
    t.integer  "cover_concept_file_size"
    t.datetime "cover_concept_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stock_cover_image_file_name"
    t.string   "stock_cover_image_content_type"
    t.integer  "stock_cover_image_file_size"
    t.datetime "stock_cover_image_updated_at"
    t.json     "image_request_list"
  end

  add_index "cover_concepts", ["project_id"], name: "index_cover_concepts_on_project_id", using: :btree

  create_table "cover_templates", force: true do |t|
    t.integer  "project_id"
    t.string   "ebook_front_cover_file_name"
    t.string   "ebook_front_cover_content_type"
    t.integer  "ebook_front_cover_file_size"
    t.datetime "ebook_front_cover_updated_at"
    t.string   "createspace_cover_file_name"
    t.string   "createspace_cover_content_type"
    t.integer  "createspace_cover_file_size"
    t.datetime "createspace_cover_updated_at"
    t.string   "lightning_source_cover_file_name"
    t.string   "lightning_source_cover_content_type"
    t.integer  "lightning_source_cover_file_size"
    t.datetime "lightning_source_cover_updated_at"
    t.string   "alternative_cover_file_name"
    t.string   "alternative_cover_content_type"
    t.integer  "alternative_cover_file_size"
    t.datetime "alternative_cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cover_templates", ["project_id"], name: "index_cover_templates_on_project_id", using: :btree

  create_table "current_tasks", force: true do |t|
    t.integer  "project_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "current_tasks", ["project_id", "task_id"], name: "index_current_tasks_on_project_id_and_task_id", unique: true, using: :btree
  add_index "current_tasks", ["project_id"], name: "index_current_tasks_on_project_id", using: :btree
  add_index "current_tasks", ["task_id"], name: "index_current_tasks_on_task_id", using: :btree

  create_table "final_manuscripts", force: true do |t|
    t.integer  "project_id"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "final_manuscripts", ["project_id"], name: "index_final_manuscripts_on_project_id", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wp_id"
  end

  add_index "genres", ["wp_id"], name: "index_genres_on_wp_id", unique: true, using: :btree

  create_table "hellosign_documents", force: true do |t|
    t.string   "name"
    t.string   "hellosign_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hellosign_signatures", force: true do |t|
    t.integer  "hellosign_document_id"
    t.integer  "team_membership_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hellosign_signatures", ["hellosign_document_id"], name: "index_hellosign_signatures_on_hellosign_document_id", using: :btree
  add_index "hellosign_signatures", ["team_membership_id"], name: "index_hellosign_signatures_on_team_membership_id", using: :btree

  create_table "imprints", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kdp_select_enrollments", force: true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.date     "enrollment_date"
    t.string   "update_type"
    t.json     "update_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kdp_select_enrollments", ["member_id"], name: "index_kdp_select_enrollments_on_member_id", using: :btree
  add_index "kdp_select_enrollments", ["project_id"], name: "index_kdp_select_enrollments_on_project_id", using: :btree

  create_table "layouts", force: true do |t|
    t.integer  "project_id"
    t.string   "layout_style_choice"
    t.string   "page_header_display_name"
    t.boolean  "use_pen_name_on_title"
    t.string   "pen_name"
    t.boolean  "use_pen_name_for_copyright"
    t.string   "exact_name_on_copyright"
    t.string   "layout_upload_file_name"
    t.string   "layout_upload_content_type"
    t.integer  "layout_upload_file_size"
    t.datetime "layout_upload_updated_at"
    t.text     "layout_notes"
    t.string   "layout_approved"
    t.datetime "layout_approved_date"
    t.json     "layout_approval_issue_list"
    t.integer  "final_page_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layouts", ["project_id"], name: "index_layouts_on_project_id", using: :btree

  create_table "manuscripts", force: true do |t|
    t.integer  "project_id"
    t.string   "original_file_name"
    t.string   "original_content_type"
    t.integer  "original_file_size"
    t.datetime "original_updated_at"
    t.string   "edited_file_name"
    t.string   "edited_content_type"
    t.integer  "edited_file_size"
    t.datetime "edited_updated_at"
    t.string   "proofed_file_name"
    t.string   "proofed_content_type"
    t.integer  "proofed_file_size"
    t.datetime "proofed_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manuscripts", ["project_id"], name: "index_manuscripts_on_project_id", using: :btree

  create_table "marketing_expenses", force: true do |t|
    t.integer  "project_id"
    t.date     "invoice_due_date"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "type_mask"
    t.integer  "service_provider_mask"
    t.float    "cost"
    t.text     "other_information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marketing_expenses", ["project_id"], name: "index_marketing_expenses_on_project_id", using: :btree

  create_table "media_kits", force: true do |t|
    t.integer  "project_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_kits", ["project_id"], name: "index_media_kits_on_project_id", using: :btree

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

  add_index "phases", ["project_view_id"], name: "index_phases_on_project_view_id", using: :btree

  create_table "price_change_promotions", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "price_promotion"
    t.float    "price_after_promotion"
    t.integer  "type_mask"
    t.integer  "sites"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "parse_ids"
  end

  add_index "price_change_promotions", ["project_id"], name: "index_price_change_promotions_on_project_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "project_type_workflows", force: true do |t|
    t.integer  "workflow_id"
    t.integer  "project_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_type_workflows", ["project_type_id"], name: "index_project_type_workflows_on_project_type_id", using: :btree
  add_index "project_type_workflows", ["workflow_id", "project_type_id"], name: "index_ptws_on_workflow_id_project_type_id", using: :btree
  add_index "project_type_workflows", ["workflow_id"], name: "index_project_type_workflows_on_workflow_id", using: :btree

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

  add_index "project_views", ["project_type_id"], name: "index_project_views_on_project_type_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "stock_image_request_link"
    t.boolean  "previously_published"
    t.string   "prev_publisher_and_date"
    t.float    "proofed_word_count"
    t.string   "teamroom_link"
    t.datetime "publication_date"
    t.datetime "marketing_release_date"
    t.string   "title"
    t.string   "final_title"
    t.text     "special_text_treatment"
    t.boolean  "has_sub_chapters"
    t.boolean  "has_index"
    t.boolean  "non_standard_size"
    t.boolean  "has_internal_illustrations"
    t.boolean  "color_interior"
    t.boolean  "childrens_book"
    t.datetime "edit_complete_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_type_id"
    t.integer  "imprint_id"
    t.integer  "wp_id"
    t.string   "slug"
  end

  add_index "projects", ["imprint_id"], name: "index_projects_on_imprint_id", using: :btree
  add_index "projects", ["project_type_id"], name: "index_projects_on_project_type_id", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  add_index "projects", ["wp_id"], name: "index_projects_on_wp_id", using: :btree

  create_table "publication_fact_sheets", force: true do |t|
    t.integer  "project_id"
    t.string   "author_name"
    t.string   "series_name"
    t.string   "series_number"
    t.text     "description"
    t.text     "author_bio"
    t.text     "endorsements"
    t.text     "one_line_blurb"
    t.float    "print_price"
    t.float    "ebook_price"
    t.string   "bisac_code_one"
    t.string   "bisac_code_two"
    t.string   "bisac_code_three"
    t.text     "search_terms"
    t.string   "age_range"
    t.string   "paperback_cover_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publication_fact_sheets", ["project_id"], name: "index_publication_fact_sheets_on_project_id", using: :btree

  create_table "published_files", force: true do |t|
    t.integer  "project_id"
    t.string   "mobi_file_name"
    t.string   "mobi_content_type"
    t.integer  "mobi_file_size"
    t.datetime "mobi_updated_at"
    t.string   "epub_file_name"
    t.string   "epub_content_type"
    t.integer  "epub_file_size"
    t.datetime "epub_updated_at"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.date     "publication_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "published_files", ["project_id"], name: "index_published_files_on_project_id", using: :btree

  create_table "required_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "project_type_id"
    t.float    "suggested_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "required_roles", ["project_type_id"], name: "index_required_roles_on_project_type_id", using: :btree
  add_index "required_roles", ["role_id"], name: "index_required_roles_on_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "contract_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status_updates", force: true do |t|
    t.integer  "project_id"
    t.integer  "type_index"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "status_updates", ["project_id"], name: "index_status_updates_on_project_id", using: :btree

  create_table "tabs", force: true do |t|
    t.integer  "task_id"
    t.integer  "phase_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tabs", ["phase_id"], name: "index_tabs_on_phase_id", using: :btree
  add_index "tabs", ["task_id"], name: "index_tabs_on_task_id", using: :btree

  create_table "task_performers", force: true do |t|
    t.integer  "task_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_performers", ["role_id"], name: "index_task_performers_on_role_id", using: :btree
  add_index "task_performers", ["task_id"], name: "index_task_performers_on_task_id", using: :btree

  create_table "task_prerequisite_fields", force: true do |t|
    t.integer  "task_id"
    t.string   "field_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_prerequisite_fields", ["task_id"], name: "index_task_prerequisite_fields_on_task_id", using: :btree

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
    t.boolean  "team_only",        default: true
  end

  add_index "tasks", ["next_id"], name: "index_tasks_on_next_id", using: :btree
  add_index "tasks", ["rejected_task_id"], name: "index_tasks_on_rejected_task_id", using: :btree
  add_index "tasks", ["workflow_id"], name: "index_tasks_on_workflow_id", using: :btree

  create_table "team_memberships", force: true do |t|
    t.integer  "project_id"
    t.integer  "member_id"
    t.integer  "role_id"
    t.float    "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_memberships", ["member_id"], name: "index_team_memberships_on_member_id", using: :btree
  add_index "team_memberships", ["project_id", "member_id", "role_id"], name: "index_team_memberships_on_project_id_and_member_id_and_role_id", using: :btree
  add_index "team_memberships", ["project_id"], name: "index_team_memberships_on_project_id", using: :btree
  add_index "team_memberships", ["role_id"], name: "index_team_memberships_on_role_id", using: :btree

  create_table "unlocked_tasks", force: true do |t|
    t.integer  "task_id"
    t.integer  "unlocked_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unlocked_tasks", ["task_id"], name: "index_unlocked_tasks_on_task_id", using: :btree
  add_index "unlocked_tasks", ["unlocked_task_id"], name: "index_unlocked_tasks_on_unlocked_task_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "roles_mask"
    t.string   "uid"
    t.string   "provider"
    t.string   "nickname"
    t.string   "website"
    t.string   "display_name"
    t.boolean  "active",                 default: true
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "workflows", force: true do |t|
    t.string   "name"
    t.integer  "root_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workflows", ["root_task_id"], name: "index_workflows_on_root_task_id", using: :btree

end
