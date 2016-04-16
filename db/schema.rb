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

ActiveRecord::Schema.define(version: 20160408002034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

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

  create_table "approve_blurbs", force: true do |t|
    t.integer  "project_id"
    t.text     "blurb_notes"
    t.string   "blurb_approval_decision"
    t.date     "blurb_approval_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "approve_blurbs", ["project_id"], name: "index_approve_blurbs_on_project_id", using: :btree

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

  create_table "bookbub_submissions", force: true do |t|
    t.integer  "project_id"
    t.integer  "submitted_by_id"
    t.string   "author"
    t.string   "title"
    t.string   "asin"
    t.string   "asin_linked_url"
    t.float    "current_price"
    t.float    "num_stars"
    t.integer  "num_reviews"
    t.integer  "num_pages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "enrollment_date"
  end

  add_index "bookbub_submissions", ["project_id"], name: "index_bookbub_submissions_on_project_id", using: :btree

  create_table "box_credentials", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "anti_forgery_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "box_credentials", ["anti_forgery_token"], name: "index_box_credentials_on_anti_forgery_token", unique: true, using: :btree

  create_table "channel_report_items", force: true do |t|
    t.integer  "channel_report_id"
    t.string   "title"
    t.string   "parse_id"
    t.boolean  "kdp_select",        default: false
    t.boolean  "amazon",            default: false
    t.boolean  "apple",             default: false
    t.boolean  "nook",              default: false
    t.string   "amazon_link"
    t.string   "apple_link"
    t.string   "nook_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channel_report_items", ["channel_report_id"], name: "index_channel_report_items_on_channel_report_id", using: :btree

  create_table "channel_reports", force: true do |t|
    t.datetime "scan_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "control_numbers", force: true do |t|
    t.integer  "project_id"
    t.float    "ebook_library_price"
    t.string   "asin"
    t.string   "apple_id"
    t.string   "epub_isbn"
    t.string   "hardback_isbn"
    t.string   "paperback_isbn"
    t.string   "parse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encore_asin"
    t.string   "bnid"
  end

  add_index "control_numbers", ["apple_id"], name: "index_control_numbers_on_apple_id", unique: true, using: :btree
  add_index "control_numbers", ["asin"], name: "index_control_numbers_on_asin", unique: true, using: :btree
  add_index "control_numbers", ["epub_isbn"], name: "index_control_numbers_on_epub_isbn", unique: true, using: :btree
  add_index "control_numbers", ["hardback_isbn"], name: "index_control_numbers_on_hardback_isbn", unique: true, using: :btree
  add_index "control_numbers", ["paperback_isbn"], name: "index_control_numbers_on_paperback_isbn", unique: true, using: :btree
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
    t.string   "cover_concept_image_direct_upload_url"
    t.boolean  "cover_concept_image_processed",         default: false
    t.string   "stock_cover_image_direct_upload_url"
    t.boolean  "stock_cover_image_processed",           default: false
    t.string   "unapproved_cover_concept_file_name"
    t.string   "unapproved_cover_concept_content_type"
    t.integer  "unapproved_cover_concept_file_size"
    t.datetime "unapproved_cover_concept_updated_at"
    t.string   "image_source"
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
    t.string   "alternative_cover_direct_upload_url"
    t.string   "alternative_cover_processed"
    t.string   "createspace_cover_direct_upload_url"
    t.string   "createspace_cover_processed"
    t.string   "ebook_front_cover_direct_upload_url"
    t.string   "ebook_front_cover_processed"
    t.string   "lightning_source_cover_direct_upload_url"
    t.string   "lightning_source_cover_processed"
    t.string   "cover_preview_file_name"
    t.string   "cover_preview_content_type"
    t.integer  "cover_preview_file_size"
    t.datetime "cover_preview_updated_at"
    t.boolean  "final_cover_approved"
    t.date     "final_cover_approval_date"
    t.text     "final_cover_notes"
    t.string   "raw_cover_file_name"
    t.string   "raw_cover_content_type"
    t.integer  "raw_cover_file_size"
    t.datetime "raw_cover_updated_at"
    t.string   "raw_cover_direct_upload_url"
    t.string   "raw_cover_processed"
    t.string   "font_license_file_name"
    t.string   "font_license_content_type"
    t.string   "font_license_file_size"
    t.string   "font_license_updated_at"
    t.string   "font_license_direct_upload_url"
    t.string   "font_license_processed"
    t.string   "font_list"
    t.string   "final_cover_screenshot_file_name"
    t.string   "final_cover_screenshot_content_type"
    t.integer  "final_cover_screenshot_file_size"
    t.datetime "final_cover_screenshot_update_at"
    t.string   "final_cover_screenshot_direct_upload_url"
    t.string   "final_cover_screenshot_processed"
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

  create_table "document_import_queues", force: true do |t|
    t.integer  "wp_id"
    t.integer  "attachment_id"
    t.string   "fieldname"
    t.string   "url"
    t.integer  "status"
    t.string   "dyno_id"
    t.string   "error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_blurbs", force: true do |t|
    t.integer  "project_id"
    t.text     "draft_blurb"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "draft_blurbs", ["project_id"], name: "index_draft_blurbs_on_project_id", using: :btree

  create_table "ebook_only_incentives", force: true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.string   "author_name"
    t.date     "publication_date"
    t.float    "retail_price"
    t.text     "blurb"
    t.string   "website_one"
    t.string   "website_two"
    t.string   "website_three"
    t.string   "category_one"
    t.string   "category_two"
    t.text     "praise"
    t.string   "isbn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "book_manager"
  end

  add_index "ebook_only_incentives", ["project_id"], name: "index_ebook_only_incentives_on_project_id", using: :btree

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
    t.string   "doc_direct_upload_url"
    t.boolean  "doc_processed",         default: false
    t.string   "pdf_direct_upload_url"
    t.boolean  "pdf_processed",         default: false
  end

  add_index "final_manuscripts", ["project_id"], name: "index_final_manuscripts_on_project_id", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wp_id"
  end

  add_index "genres", ["wp_id"], name: "index_genres_on_wp_id", unique: true, using: :btree

  create_table "hellosign_document_types", force: true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "message"
    t.string   "template_id"
    t.json     "signers"
    t.json     "ccs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "version"
    t.string   "display_name"
  end

  add_index "hellosign_document_types", ["name"], name: "index_hellosign_document_types_on_name", unique: true, using: :btree

  create_table "hellosign_documents", force: true do |t|
    t.string   "hellosign_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hellosign_document_type_id"
    t.integer  "team_membership_id"
    t.string   "signing_url"
    t.string   "files_url"
    t.string   "details_url"
    t.boolean  "is_complete",                default: false
    t.boolean  "pending_cancellation",       default: false
    t.boolean  "cancelled",                  default: false
    t.boolean  "has_error",                  default: false
  end

  add_index "hellosign_documents", ["hellosign_document_type_id"], name: "index_hellosign_documents_on_hellosign_document_type_id", using: :btree
  add_index "hellosign_documents", ["team_membership_id"], name: "index_hellosign_documents_on_team_membership_id", using: :btree

  create_table "hellosign_signatures", force: true do |t|
    t.integer  "hellosign_document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "signature_id"
    t.string   "signer_email_address"
    t.string   "signer_name"
    t.integer  "order"
    t.string   "status_code"
    t.string   "error"
    t.datetime "signed_at"
    t.datetime "last_viewed_at"
    t.datetime "last_reminded_at"
    t.integer  "member_id"
  end

  add_index "hellosign_signatures", ["hellosign_document_id"], name: "index_hellosign_signatures_on_hellosign_document_id", using: :btree
  add_index "hellosign_signatures", ["member_id"], name: "index_hellosign_signatures_on_member_id", using: :btree

  create_table "imported_contracts", force: true do |t|
    t.string   "document_type"
    t.text     "document_signers",           default: [], array: true
    t.date     "document_date"
    t.integer  "project_id"
    t.string   "contract_file_name"
    t.string   "contract_content_type"
    t.integer  "contract_file_size"
    t.datetime "contract_updated_at"
    t.string   "contract_direct_upload_url"
    t.boolean  "contract_processed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imported_contracts", ["document_type"], name: "index_imported_contracts_on_document_type", using: :btree
  add_index "imported_contracts", ["project_id"], name: "index_imported_contracts_on_project_id", using: :btree

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
    t.string   "layout_upload_direct_upload_url"
    t.string   "layout_upload_processed"
    t.float    "trim_size_w"
    t.float    "trim_size_h"
    t.string   "legal_name"
  end

  add_index "layouts", ["project_id"], name: "index_layouts_on_project_id", using: :btree

  create_table "man_devs", force: true do |t|
    t.integer  "project_id"
    t.string   "man_dev_decision"
    t.datetime "man_dev_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "man_devs", ["project_id"], name: "index_man_devs_on_project_id", using: :btree

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
    t.string   "proofread_final_file_name"
    t.string   "proofread_final_content_type"
    t.integer  "proofread_final_file_size"
    t.datetime "proofread_final_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_file_direct_upload_url"
    t.boolean  "original_file_processed",                   default: false
    t.string   "edited_file_direct_upload_url"
    t.boolean  "edited_file_processed",                     default: false
    t.string   "proofread_final_file_direct_upload_url"
    t.boolean  "proofread_final_file_processed",            default: false
    t.string   "proofread_reviewed_content_type"
    t.string   "proofread_reviewed_file_direct_upload_url"
    t.string   "proofread_reviewed_file_name"
    t.boolean  "proofread_reviewed_file_processed"
    t.integer  "proofread_reviewed_file_size"
    t.datetime "proofread_reviewed_updated_at"
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
    t.string   "other_service_provider"
    t.string   "other_type"
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
    t.string   "document_direct_upload_url"
    t.boolean  "document_processed",         default: false
  end

  add_index "media_kits", ["project_id"], name: "index_media_kits_on_project_id", using: :btree

  create_table "monthly_published_books", force: true do |t|
    t.date     "report_date"
    t.integer  "published_monthly"
    t.integer  "published_total"
    t.json     "published_books"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monthly_published_books", ["report_date"], name: "index_monthly_published_books_on_report_date", using: :btree

  create_table "netgalley_submissions", force: true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.string   "author_name"
    t.date     "publication_date"
    t.float    "retail_price"
    t.text     "blurb"
    t.string   "website_one"
    t.string   "website_two"
    t.string   "website_three"
    t.string   "category_one"
    t.string   "category_two"
    t.text     "praise"
    t.string   "isbn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "book_manager"
    t.boolean  "personal_submission"
    t.string   "paypal_email"
  end

  add_index "netgalley_submissions", ["project_id"], name: "index_netgalley_submissions_on_project_id", using: :btree

  create_table "parse_books", force: true do |t|
    t.string   "parse_id"
    t.string   "apple_id"
    t.string   "asin"
    t.string   "author"
    t.string   "bnid"
    t.string   "createspace_isbn"
    t.string   "detail_page_url_nook"
    t.string   "detail_url_apple"
    t.string   "detail_url_google_play"
    t.string   "detail_url"
    t.string   "epub_isbn"
    t.string   "epub_isbn_itunes"
    t.string   "google_play_url"
    t.string   "hardback_isbn"
    t.string   "image_url_google_play"
    t.string   "image_url_nook"
    t.string   "inclusion_asin"
    t.string   "kdp_url"
    t.string   "large_image_apple"
    t.string   "large_image"
    t.string   "lightning_source"
    t.string   "meta_comet_id"
    t.string   "nook_url"
    t.string   "paperback_isbn"
    t.date     "publication_date_amazon"
    t.string   "publisher"
    t.integer  "teamtrope_id"
    t.integer  "teamtrope_project_id"
    t.string   "title"
    t.date     "parse_created_at"
    t.date     "parse_updated_at"
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

  add_index "phases", ["project_view_id"], name: "index_phases_on_project_view_id", using: :btree

  create_table "prefunk_enrollments", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prefunk_enrollments", ["project_id"], name: "index_prefunk_enrollments_on_project_id", using: :btree
  add_index "prefunk_enrollments", ["user_id"], name: "index_prefunk_enrollments_on_user_id", using: :btree

  create_table "price_change_promotions", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "price_promotion"
    t.float    "price_after_promotion"
    t.integer  "type_mask"
    t.integer  "sites_mask"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "parse_ids"
    t.boolean  "validated",             default: false
  end

  add_index "price_change_promotions", ["project_id"], name: "index_price_change_promotions_on_project_id", using: :btree

  create_table "print_corners", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "order_type"
    t.boolean  "first_order"
    t.boolean  "additional_order"
    t.boolean  "over_125"
    t.boolean  "billing_acceptance"
    t.integer  "quantity"
    t.boolean  "has_author_profile"
    t.boolean  "has_marketing_plan"
    t.string   "shipping_recipient"
    t.string   "shipping_address_street_1"
    t.string   "shipping_address_street_2"
    t.string   "shipping_address_city"
    t.string   "shipping_address_state"
    t.string   "shipping_address_zip"
    t.string   "shipping_address_country"
    t.string   "marketing_plan_link"
    t.text     "marketing_copy_message"
    t.string   "contact_phone"
    t.text     "expedite_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_corners", ["project_id"], name: "index_print_corners_on_project_id", using: :btree
  add_index "print_corners", ["user_id"], name: "index_print_corners_on_user_id", using: :btree

  create_table "production_expenses", force: true do |t|
    t.integer  "project_id"
    t.integer  "total_quantity_ordered"
    t.float    "total_cost"
    t.integer  "complimentary_quantity"
    t.float    "complimentary_cost"
    t.integer  "author_advance_quantity"
    t.float    "author_advance_cost"
    t.integer  "purchased_quantity"
    t.float    "purchased_cost"
    t.float    "paypal_invoice_amount"
    t.text     "calculation_explanation"
    t.integer  "marketing_quantity"
    t.integer  "additional_cost_mask"
    t.float    "additional_team_cost"
    t.float    "additional_booktrope_cost"
    t.date     "effective_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "marketing_cost"
  end

  add_index "production_expenses", ["project_id"], name: "index_production_expenses_on_project_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "avatar_url"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "project_grid_table_rows", force: true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.string   "genre"
    t.string   "author"
    t.string   "editor"
    t.string   "proofreader"
    t.string   "project_manager"
    t.string   "book_manager"
    t.string   "cover_designer"
    t.string   "imprint"
    t.string   "teamroom_link"
    t.integer  "production_task_id"
    t.string   "production_task_name"
    t.integer  "marketing_task_id"
    t.string   "marketing_task_name"
    t.integer  "design_task_id"
    t.string   "design_task_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "production_task_last_update"
    t.datetime "marketing_task_last_update"
    t.datetime "design_task_last_update"
    t.string   "production_task_display_name"
    t.string   "design_task_display_name"
    t.string   "marketing_task_display_name"
    t.string   "author_last_first"
    t.string   "author_first_last"
    t.string   "pfs_author_name"
    t.text     "other_contributors"
    t.text     "team_and_pct"
    t.string   "asin"
    t.string   "paperback_isbn"
    t.string   "epub_isbn"
    t.string   "book_format"
    t.date     "publication_date"
    t.integer  "page_count"
    t.string   "formatted_print_price"
    t.string   "formatted_ebook_price"
    t.string   "formatted_library_price"
    t.string   "bisac_one_code"
    t.string   "bisac_one_description"
    t.string   "bisac_two_code"
    t.string   "bisac_two_description"
    t.string   "bisac_three_code"
    t.string   "bisac_three_description"
    t.text     "search_terms"
    t.text     "description"
    t.text     "author_bio"
    t.text     "one_line_blurb"
    t.string   "series_name"
    t.string   "series_number"
    t.string   "prefunk_enrolled"
    t.string   "prefunk_enrollment_date"
    t.text     "authors_pct"
    t.text     "editors_pct"
    t.text     "book_managers_pct"
    t.text     "cover_designers_pct"
    t.text     "project_managers_pct"
    t.text     "proofreaders_pct"
    t.float    "total_pct"
    t.boolean  "archived",                     default: false
  end

  add_index "project_grid_table_rows", ["design_task_id"], name: "index_project_grid_table_rows_on_design_task_id", using: :btree
  add_index "project_grid_table_rows", ["design_task_name"], name: "index_project_grid_table_rows_on_design_task_name", using: :btree
  add_index "project_grid_table_rows", ["marketing_task_id"], name: "index_project_grid_table_rows_on_marketing_task_id", using: :btree
  add_index "project_grid_table_rows", ["marketing_task_name"], name: "index_project_grid_table_rows_on_marketing_task_name", using: :btree
  add_index "project_grid_table_rows", ["production_task_id"], name: "index_project_grid_table_rows_on_production_task_id", using: :btree
  add_index "project_grid_table_rows", ["project_id"], name: "index_project_grid_table_rows_on_project_id", using: :btree
  add_index "project_grid_table_rows", ["title"], name: "index_project_grid_table_rows_on_title", using: :btree

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
    t.integer  "proofed_word_count"
    t.string   "teamroom_link"
    t.datetime "publication_date"
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
    t.text     "synopsis"
    t.boolean  "lock",                           default: false
    t.boolean  "done",                           default: false
    t.string   "previously_published_title"
    t.integer  "previously_published_year"
    t.string   "previously_published_publisher"
    t.text     "credit_request"
    t.integer  "page_count"
    t.date     "target_market_launch_date"
    t.string   "book_type"
    t.string   "createspace_store_url"
    t.string   "createspace_coupon_code"
    t.boolean  "enable_rights_request",          default: false
    t.boolean  "table_of_contents"
    t.boolean  "archived",                       default: false
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
    t.string   "bisac_code_name_one"
    t.string   "bisac_code_name_two"
    t.string   "bisac_code_name_three"
    t.integer  "starting_grade_index"
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
    t.string   "mobi_direct_upload_url"
    t.boolean  "mobi_processed",         default: false
    t.string   "epub_direct_upload_url"
    t.boolean  "epub_processed",         default: false
    t.string   "pdf_direct_upload_url"
    t.boolean  "pdf_processed",          default: false
  end

  add_index "published_files", ["project_id"], name: "index_published_files_on_project_id", using: :btree

  create_table "report_data_countries", force: true do |t|
    t.string   "name"
    t.string   "code_iso"
    t.string   "code_un"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_data_files", force: true do |t|
    t.binary   "source_file"
    t.string   "filename"
    t.boolean  "is_valid",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_data_kdp_types", force: true do |t|
    t.string   "kdp_transaction_type"
    t.string   "kdp_royalty_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_data_kdp_types", ["kdp_transaction_type", "kdp_royalty_type"], name: "index_kdp_types", unique: true, using: :btree

  create_table "report_data_monthly_sales", force: true do |t|
    t.integer  "report_data_file_id"
    t.integer  "report_data_source_id"
    t.integer  "project_id"
    t.integer  "report_data_kdp_type_id"
    t.integer  "report_data_country_id"
    t.boolean  "is_valid"
    t.integer  "year"
    t.integer  "month"
    t.integer  "quantity",                default: 0
    t.float    "revenue",                 default: 0.0
    t.float    "list_price",              default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_data_monthly_sales", ["project_id"], name: "index_report_data_monthly_sales_on_project_id", using: :btree
  add_index "report_data_monthly_sales", ["report_data_file_id"], name: "index_report_data_monthly_sales_on_report_data_file_id", using: :btree
  add_index "report_data_monthly_sales", ["report_data_source_id", "year", "month", "is_valid"], name: "index_monthly_sales_by_source", using: :btree
  add_index "report_data_monthly_sales", ["report_data_source_id"], name: "index_report_data_monthly_sales_on_report_data_source_id", using: :btree
  add_index "report_data_monthly_sales", ["year", "month", "is_valid"], name: "index_monthly_sales", using: :btree

  create_table "report_data_rows", force: true do |t|
    t.integer  "report_data_file_id"
    t.integer  "project_id"
    t.boolean  "is_valid",             default: true
    t.string   "source_table_name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "quantity"
    t.float    "revenue_multiccy"
    t.string   "currency_use"
    t.string   "country"
    t.string   "bn_identifier"
    t.string   "epub_isbn"
    t.string   "paperback_isbn"
    t.string   "apple_identifier"
    t.string   "asin"
    t.string   "kdp_royalty_type"
    t.string   "kdp_transaction_type"
    t.string   "list_price_multiccy"
    t.string   "isbn_hardcover"
    t.float    "unit_revenue"
    t.float    "revenue_usd"
    t.string   "author"
    t.string   "title"
    t.string   "imprint"
    t.datetime "sale_date"
    t.string   "retailer"
    t.string   "period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_data_rows", ["project_id"], name: "index_report_data_rows_on_project_id", using: :btree
  add_index "report_data_rows", ["report_data_file_id"], name: "index_report_data_rows_on_report_data_file_id", using: :btree

  create_table "report_data_sources", force: true do |t|
    t.string   "name"
    t.string   "name_short"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "required_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "project_type_id"
    t.float    "suggested_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "required_roles", ["project_type_id"], name: "index_required_roles_on_project_type_id", using: :btree
  add_index "required_roles", ["role_id", "project_type_id"], name: "index_required_roles_on_role_id_and_project_type_id", unique: true, using: :btree
  add_index "required_roles", ["role_id"], name: "index_required_roles_on_role_id", using: :btree

  create_table "rights_back_requests", force: true do |t|
    t.integer  "project_id"
    t.string   "submitted_by_name"
    t.integer  "submitted_by_id"
    t.string   "title"
    t.string   "author"
    t.text     "reason"
    t.boolean  "proofed"
    t.boolean  "edited"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rights_back_requests", ["project_id"], name: "index_rights_back_requests_on_project_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "contract_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_agreement",      default: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "social_media_marketings", force: true do |t|
    t.integer  "project_id"
    t.string   "author_facebook_page"
    t.string   "author_central_account_link"
    t.string   "website_url"
    t.string   "twitter"
    t.string   "pintrest"
    t.string   "goodreads"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_media_marketings", ["project_id"], name: "index_social_media_marketings_on_project_id", using: :btree

  create_table "tabs", force: true do |t|
    t.integer  "task_id"
    t.integer  "phase_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tabs", ["phase_id"], name: "index_tabs_on_phase_id", using: :btree
  add_index "tabs", ["task_id"], name: "index_tabs_on_task_id", using: :btree

  create_table "task_dependencies", force: true do |t|
    t.integer  "main_task_id"
    t.integer  "dependent_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_dependencies", ["dependent_task_id"], name: "index_task_dependencies_on_dependent_task_id", using: :btree
  add_index "task_dependencies", ["main_task_id", "dependent_task_id"], name: "index_task_dependencies_on_main_task_id_and_dependent_task_id", using: :btree
  add_index "task_dependencies", ["main_task_id"], name: "index_task_dependencies_on_main_task_id", using: :btree

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
    t.string   "override_name"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "workflows", force: true do |t|
    t.string   "name"
    t.integer  "root_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workflows", ["root_task_id"], name: "index_workflows_on_root_task_id", using: :btree

end
