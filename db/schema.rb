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

ActiveRecord::Schema.define(version: 20141127000910) do

  create_table "post_tags", force: true do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_tags", ["post_id", "tag_id"], name: "index_post_tags_on_post_id_and_tag_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.datetime "post_date"
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["post_date", "title", "author_id"], name: "index_posts_on_post_date_and_title_and_author_id"
  add_index "posts", ["post_date", "title"], name: "index_posts_on_post_date_and_title"

  create_table "process_control_records", force: true do |t|
    t.float    "days_to_complete_book"
    t.integer  "intro_video"
    t.integer  "who_can_complete"
    t.boolean  "is_approval_step"
    t.float    "days_to_complete_step"
    t.integer  "not_approved_go_to"
    t.string   "tab_text"
    t.string   "help_link"
    t.string   "step_name"
    t.string   "form_name"
    t.string   "prereq_fields"
    t.integer  "show_steps"
    t.integer  "workflow"
    t.string   "icon"
    t.integer  "phase"
    t.integer  "next_step"
    t.boolean  "is_process_step"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "final_doc_file"
    t.integer  "final_manuscript_pdf"
    t.integer  "final_pdf"
    t.string   "stock_image_request_link"
    t.datetime "pcr_step_date"
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
    t.datetime "production_exception_date"
    t.datetime "marketing_release_date"
    t.string   "production_exception_reason"
    t.integer  "production_exception_approver"
    t.boolean  "production_exception"
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
    t.integer  "project_manager"
    t.float    "other_pct"
    t.integer  "manuscript_proofed"
    t.float    "proofreader_pct"
    t.integer  "genre"
    t.float    "designer_pct"
    t.float    "editor_pct"
    t.float    "manager_pct"
    t.float    "project_manager_pct"
    t.datetime "edit_complete_date"
    t.float    "author_pct"
    t.integer  "other3"
    t.integer  "other2"
    t.integer  "other"
    t.integer  "author"
    t.integer  "editor"
    t.integer  "marketing_manager"
    t.integer  "manuscript_original"
    t.integer  "cover_designer"
    t.integer  "proofreader"
    t.float    "other3_pct"
    t.float    "other2_pct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "apple_id"
    t.string   "asin"
    t.string   "epub_isbn_no_dash"
    t.string   "createspace_isbn"
    t.string   "hardback_isbn"
    t.string   "lsi_isbn"
    t.string   "isbn"
    t.string   "ebook_isbn"
    t.string   "parse_id"
    t.string   "step_mkt_info"
    t.string   "step_cover_design"
    t.string   "pcr_step"
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

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["id", "name"], name: "index_tags_on_id_and_name"
  add_index "tags", ["name"], name: "index_tags_on_name"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
