BookGenre.create!([
  {id: 1, project_id: 1, genre_id: 1, created_at: "2015-01-20 15:32:59", updated_at: "2015-01-20 15:32:59"},
  {id: 2, project_id: 2, genre_id: 1, created_at: "2015-02-02 22:48:23", updated_at: "2015-02-02 22:48:23"}
])
Comment.create!([
  {id: 1, content: "I just updated my comment.\r\n", user_id: 1, post_id: 1, created_at: "2015-01-21 04:06:11", updated_at: "2015-01-21 04:09:55"},
  {id: 2, content: "テスト", user_id: 2, post_id: 1, created_at: "2015-01-21 04:13:38", updated_at: "2015-01-21 04:13:38"}
])
CurrentTask.create!([
  {id: 1, project_id: 1, task_id: 5, created_at: "2015-01-20 09:55:02", updated_at: "2015-01-20 09:55:02"},
  {id: 2, project_id: 1, task_id: 1, created_at: "2015-01-20 10:04:02", updated_at: "2015-01-20 10:04:02"},
  {id: 3, project_id: 2, task_id: 2, created_at: "2015-02-05 06:25:48", updated_at: "2015-02-05 06:25:48"}
])
Genre.create!([
  {id: 1, name: "Fiction", created_at: "2015-01-20 15:32:37", updated_at: "2015-01-20 15:32:37"}
])
Phase.create!([
  {id: 8, project_view_id: 1, name: "Overview", color: "white", color_value: "#eee", icon: "icon-dashboard", order: 0, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 7, project_view_id: 1, name: "Build Team", color: "yellow", color_value: "#F0D818", icon: "icon-wrench", order: 1, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 6, project_view_id: 1, name: "Edit Content", color: "red", color_value: "#E6583E", icon: "icon-pencil", order: 2, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 5, project_view_id: 1, name: "Design Layout", color: "medblue", color_value: "#0078c0", icon: "icon-screenshot", order: 3, created_at: "2015-01-20 08:00:13", updated_at: "2015-02-02 23:40:24"},
  {id: 4, project_view_id: 1, name: "Design Cover", color: "blue", color_value: "#1394BB", icon: "icon-screenshot", order: 4, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 3, project_view_id: 1, name: "Publish", color: "brown", color_value: "#8B7A6A", icon: "icon-book", order: 5, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 2, project_view_id: 1, name: "Marketing", color: "green", color_value: "#AED991", icon: "icon-bullhorn", order: 6, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"},
  {id: 1, project_view_id: 1, name: "Promotions", color: "green", color_value: "#AED991", icon: "icon-bullhorn", order: 7, created_at: "2015-01-20 08:00:13", updated_at: "2015-01-20 08:13:05"}
])
Post.create!([
  {id: 1, title: "Test Post", post_date: "2015-01-13 04:00:00", author_id: 1, content: "The post.", created_at: "2015-01-19 10:01:10", updated_at: "2015-02-06 04:20:50", featured_image_file_name: "IMG_0677.JPG", featured_image_content_type: "image/jpeg", featured_image_file_size: 2709585, featured_image_updated_at: "2015-02-06 04:20:50"},
  {id: 2, title: "Test Post", post_date: "2015-01-13 04:00:00", author_id: 1, content: "The post.", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10", featured_image_file_name: nil, featured_image_content_type: nil, featured_image_file_size: nil, featured_image_updated_at: nil}
])
PostTag.create!([
  {id: 1, post_id: 1, tag_id: 1, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"}
])
Project.create!([
  {id: 1, final_doc_file: nil, final_manuscript_pdf: nil, final_pdf: nil, stock_image_request_link: "", layout_notes: "", previously_published: nil, prev_publisher_and_date: "", stock_cover_image: nil, cover_concept_notes: "", proofed_word_count: nil, cover_concept: nil, teamroom_link: "", final_mobi: nil, publication_date: nil, final_epub: nil, marketing_release_date: nil, paperback_cover_type: "", age_range: "", search_terms: "", bisac_code_3: "", bisac_code_2: "", bisac_code_1: "", ebook_price: nil, print_price: nil, blurb_one_line: "", endorsements: "", author_bio: "", blurb_description: "", final_title: "Between Boyfriends", cover_art_approval_date: nil, alternative_cover_template: nil, createspace_cover: nil, lightning_source_cover: nil, ebook_front_cover: nil, layout_approved_date: nil, final_page_count: nil, layout_upload: nil, use_pen_name_on_title: nil, use_pen_name_for_copyright: nil, exact_name_on_copyright: "", pen_name: "", special_text_treatment: "", has_sub_chapters: nil, layout_style_choice: "", has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, manuscript_edited: nil, childrens_book: nil, manuscript_proofed: nil, edit_complete_date: "2015-01-29 00:00:00", manuscript_original: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-20 11:49:42", project_type_id: 1},
  {id: 2, final_doc_file: nil, final_manuscript_pdf: nil, final_pdf: nil, stock_image_request_link: "", layout_notes: "", previously_published: nil, prev_publisher_and_date: "", stock_cover_image: nil, cover_concept_notes: "", proofed_word_count: nil, cover_concept: nil, teamroom_link: "", final_mobi: nil, publication_date: nil, final_epub: nil, marketing_release_date: nil, paperback_cover_type: "", age_range: "", search_terms: "", bisac_code_3: "", bisac_code_2: "", bisac_code_1: "", ebook_price: nil, print_price: nil, blurb_one_line: "", endorsements: "", author_bio: "", blurb_description: "", final_title: "Atolovus by David Covenant", cover_art_approval_date: nil, alternative_cover_template: nil, createspace_cover: nil, lightning_source_cover: nil, ebook_front_cover: nil, layout_approved_date: nil, final_page_count: nil, layout_upload: nil, use_pen_name_on_title: nil, use_pen_name_for_copyright: nil, exact_name_on_copyright: "", pen_name: "", special_text_treatment: "", has_sub_chapters: nil, layout_style_choice: "", has_index: nil, non_standard_size: nil, has_internal_illustrations: nil, color_interior: nil, manuscript_edited: nil, childrens_book: nil, manuscript_proofed: nil, edit_complete_date: nil, manuscript_original: nil, created_at: "2015-01-21 05:16:25", updated_at: "2015-02-02 22:48:23", project_type_id: 1}
])
Role.create!([
  {id: 1, name: "Author", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 2, name: "Book Manager", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 3, name: "Cover Designer", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 4, name: "Editor", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 6, name: "Project Manager", created_at: "2015-01-19 22:31:31", updated_at: "2015-01-19 22:31:31"},
  {id: 5, name: "Proof Reader", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"}
])
ProjectType.create!([
  {id: 1, name: "Standard Project", team_total_percent: 70.0, created_at: "2015-01-19 22:46:34", updated_at: "2015-01-19 22:46:34"}
])
ProjectTypeWorkflow.create!([
  {id: 1, workflow_id: 1, project_type_id: 1, created_at: "2015-01-21 02:21:31", updated_at: "2015-01-21 02:21:31"},
  {id: 2, workflow_id: 2, project_type_id: 1, created_at: "2015-01-20 09:36:59", updated_at: "2015-01-20 09:36:59"},
  {id: 3, workflow_id: 3, project_type_id: 1, created_at: "2015-01-20 09:38:11", updated_at: "2015-01-20 09:38:11"}
])
ProjectView.create!([
  {id: 1, project_type_id: 1, created_at: "2015-01-20 08:11:10", updated_at: "2015-01-20 08:11:10"}
])
RequiredRole.create!([
  {id: 1, role_id: 1, project_type_id: 1, suggested_percent: 33.0, created_at: "2015-01-19 22:58:20", updated_at: "2015-01-19 22:58:20"},
  {id: 2, role_id: 2, project_type_id: 1, suggested_percent: 20.0, created_at: "2015-01-19 23:01:07", updated_at: "2015-01-19 23:01:07"},
  {id: 3, role_id: 3, project_type_id: 1, suggested_percent: 4.0, created_at: "2015-01-19 23:01:31", updated_at: "2015-01-19 23:01:31"},
  {id: 4, role_id: 4, project_type_id: 1, suggested_percent: 7.0, created_at: "2015-01-19 23:02:01", updated_at: "2015-01-19 23:02:01"},
  {id: 5, role_id: 6, project_type_id: 1, suggested_percent: 4.0, created_at: "2015-01-19 23:02:11", updated_at: "2015-01-19 23:02:11"},
  {id: 6, role_id: 5, project_type_id: 1, suggested_percent: 2.0, created_at: "2015-01-19 23:02:32", updated_at: "2015-01-19 23:02:32"}
])
Tab.create!([
  {id: 8, task_id: 1, phase_id: 7, order: 1, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 12, task_id: 5, phase_id: 6, order: 1, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 17, task_id: 9, phase_id: 8, order: 1, created_at: "2015-02-02 23:03:12", updated_at: "2015-02-02 23:53:14"},
  {id: 23, task_id: 15, phase_id: 5, order: 1, created_at: "2015-02-02 23:13:10", updated_at: "2015-02-02 23:53:14"},
  {id: 27, task_id: 19, phase_id: 4, order: 1, created_at: "2015-02-02 23:28:18", updated_at: "2015-02-02 23:53:14"},
  {id: 32, task_id: 24, phase_id: 3, order: 1, created_at: "2015-02-02 23:30:41", updated_at: "2015-02-02 23:53:14"},
  {id: 35, task_id: 27, phase_id: 2, order: 1, created_at: "2015-02-02 23:33:41", updated_at: "2015-02-02 23:53:14"},
  {id: 40, task_id: 32, phase_id: 1, order: 1, created_at: "2015-02-02 23:36:15", updated_at: "2015-02-02 23:53:14"},
  {id: 9, task_id: 2, phase_id: 7, order: 2, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 13, task_id: 6, phase_id: 6, order: 2, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 18, task_id: 10, phase_id: 8, order: 2, created_at: "2015-02-02 23:03:12", updated_at: "2015-02-02 23:53:14"},
  {id: 24, task_id: 16, phase_id: 5, order: 2, created_at: "2015-02-02 23:24:06", updated_at: "2015-02-02 23:53:14"},
  {id: 28, task_id: 20, phase_id: 4, order: 2, created_at: "2015-02-02 23:28:18", updated_at: "2015-02-02 23:53:14"},
  {id: 33, task_id: 25, phase_id: 3, order: 2, created_at: "2015-02-02 23:30:41", updated_at: "2015-02-02 23:53:14"},
  {id: 36, task_id: 28, phase_id: 2, order: 2, created_at: "2015-02-02 23:33:41", updated_at: "2015-02-02 23:53:14"},
  {id: 41, task_id: 33, phase_id: 1, order: 2, created_at: "2015-02-02 23:36:15", updated_at: "2015-02-02 23:53:14"},
  {id: 10, task_id: 3, phase_id: 7, order: 3, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 14, task_id: 7, phase_id: 6, order: 3, created_at: "2015-01-20 20:50:15", updated_at: "2015-02-02 23:53:14"},
  {id: 19, task_id: 11, phase_id: 8, order: 3, created_at: "2015-02-02 23:06:23", updated_at: "2015-02-02 23:53:14"},
  {id: 25, task_id: 17, phase_id: 5, order: 3, created_at: "2015-02-02 23:24:06", updated_at: "2015-02-02 23:53:14"},
  {id: 29, task_id: 21, phase_id: 4, order: 3, created_at: "2015-02-02 23:28:18", updated_at: "2015-02-02 23:53:14"},
  {id: 34, task_id: 26, phase_id: 3, order: 3, created_at: "2015-02-02 23:30:41", updated_at: "2015-02-02 23:53:14"},
  {id: 37, task_id: 29, phase_id: 2, order: 3, created_at: "2015-02-02 23:33:41", updated_at: "2015-02-02 23:53:14"},
  {id: 42, task_id: 34, phase_id: 1, order: 3, created_at: "2015-02-02 23:36:49", updated_at: "2015-02-02 23:53:14"},
  {id: 16, task_id: 4, phase_id: 7, order: 4, created_at: "2015-01-20 21:18:34", updated_at: "2015-02-02 23:53:14"},
  {id: 26, task_id: 18, phase_id: 5, order: 4, created_at: "2015-02-02 23:24:06", updated_at: "2015-02-02 23:53:14"},
  {id: 30, task_id: 22, phase_id: 4, order: 4, created_at: "2015-02-02 23:28:18", updated_at: "2015-02-02 23:53:14"},
  {id: 38, task_id: 30, phase_id: 2, order: 4, created_at: "2015-02-02 23:33:41", updated_at: "2015-02-02 23:53:14"},
  {id: 43, task_id: 36, phase_id: 1, order: 4, created_at: "2015-02-02 23:36:49", updated_at: "2015-02-02 23:53:14"},
  {id: 44, task_id: 37, phase_id: 6, order: 4, created_at: "2015-02-03 00:09:30", updated_at: "2015-02-03 00:09:30"},
  {id: 46, task_id: 12, phase_id: 8, order: 4, created_at: "2015-02-10 02:47:16", updated_at: "2015-02-10 02:47:16"},
  {id: 21, task_id: 13, phase_id: 8, order: 5, created_at: "2015-02-02 23:06:23", updated_at: "2015-02-02 23:53:14"},
  {id: 31, task_id: 23, phase_id: 4, order: 5, created_at: "2015-02-02 23:28:18", updated_at: "2015-02-02 23:53:14"},
  {id: 39, task_id: 31, phase_id: 2, order: 5, created_at: "2015-02-02 23:33:41", updated_at: "2015-02-02 23:53:14"},
  {id: 45, task_id: 38, phase_id: 7, order: 5, created_at: "2015-02-03 11:10:25", updated_at: "2015-02-03 11:10:25"},
  {id: 22, task_id: 14, phase_id: 8, order: 7, created_at: "2015-02-02 23:06:23", updated_at: "2015-02-02 23:53:14"}
])
Tag.create!([
  {id: 1, name: "awesome tag", created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"}
])
Task.create!([
  {id: 1, workflow_id: 1, next_id: nil, rejected_task_id: 2, partial: "project_interest", name: "Project Interest", icon: "icon-lightbulb", tab_text: "Project Interest", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-02-03 11:12:13"},
  {id: 2, workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "accept_member", name: "Accept Member", icon: "icon-thumbs-up", tab_text: "Accept Member", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-02-03 11:11:42"},
  {id: 3, workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "form_1099", name: "1099 Form", icon: "icon-cogs", tab_text: "1099 Form", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-02-03 11:11:31"},
  {id: 4, workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "revenue_split", name: "Revenue Split", icon: "icon-money", tab_text: "Revenue Split", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-02-03 11:23:58"},
  {id: 5, workflow_id: 1, next_id: 6, rejected_task_id: nil, partial: "original_manuscript", name: "Original Manuscript", icon: "icon-bookmark", tab_text: "Orig. Man.", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 6, workflow_id: 1, next_id: 7, rejected_task_id: nil, partial: "edit_complete_date", name: "Submit Edit Complete Date", icon: "icon-calendar", tab_text: "Submit Edit Complete Date", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 7, workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: "edited_manuscript", name: "Submit Edited Manuscript", icon: "icon-edit", tab_text: "Submit Edited Manuscript", intro_video: "", days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 8, workflow_id: 1, next_id: nil, rejected_task_id: nil, partial: nil, name: "foo", icon: nil, tab_text: nil, intro_video: nil, days_to_complete: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 9, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "project_details", name: "Details", icon: "icon-file-alt", tab_text: "Details", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:00:06", updated_at: "2015-02-02 23:56:30"},
  {id: 10, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "assets", name: "Assets", icon: "icon-folder-open", tab_text: "Assets", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:02:40", updated_at: "2015-02-02 23:08:52"},
  {id: 11, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "team", name: "Team", icon: "icon-group", tab_text: "Team", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:04:12", updated_at: "2015-02-02 23:59:04"},
  {id: 12, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "analytics", name: "Analytics", icon: "icon-bar-chart", tab_text: "Analytics", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:04:43", updated_at: "2015-02-05 20:35:19"},
  {id: 13, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "update", name: "Update", icon: "icon-lightbulb", tab_text: "Update", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:05:11", updated_at: "2015-02-03 10:27:11"},
  {id: 14, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "control_numbers", name: "Control Numbers", icon: "icon-cogs", tab_text: "Ctrl No.", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:05:38", updated_at: "2015-02-02 23:59:50"},
  {id: 15, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "choose_style", name: "Choose Style", icon: "icon-adjust", tab_text: "Choose Style", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:12:24", updated_at: "2015-02-03 11:37:16"},
  {id: 16, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "upload_layout", name: "Upload  Layout", icon: "icon-cloud-upload", tab_text: "Upload Layout", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:16:02", updated_at: "2015-02-03 11:39:22"},
  {id: 17, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "approve_layout", name: "Approve Layout", icon: "icon-thumbs-up", tab_text: "Approve Layout", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:17:11", updated_at: "2015-02-03 11:40:59"},
  {id: 18, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "page_count", name: "Page Count", icon: "icon-list-ol", tab_text: "Page Count", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:18:14", updated_at: "2015-02-03 11:42:13"},
  {id: 19, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "upload_cover_concept", name: "Cover Concept", icon: "icon-bookmark", tab_text: "Cover Concept", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:25:26", updated_at: "2015-02-04 03:46:44"},
  {id: 20, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "approve_cover_art", name: "Approve Cover Art", icon: "icon-thumbs-up", tab_text: "Approve Cover Art", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:25:55", updated_at: "2015-02-04 03:54:07"},
  {id: 21, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "request_image", name: "Request Image", icon: "icon-adjust", tab_text: "Request Image", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:26:23", updated_at: "2015-02-04 04:01:29"},
  {id: 22, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "add_image", name: "Add Image", icon: "icon-adjust", tab_text: "Add Image", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:26:44", updated_at: "2015-02-04 04:04:40"},
  {id: 23, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "upload_cover_templates", name: "Final Covers", icon: "icon-cloud-upload", tab_text: "Final Covers", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:27:16", updated_at: "2015-02-04 04:08:46"},
  {id: 24, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "submit_publication_fact_sheet", name: "Submit PFS", icon: "icon-bookmark", tab_text: "Submit PFS", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:29:16", updated_at: "2015-02-04 04:14:05"},
  {id: 25, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "final_manuscript", name: "Final Manuscript", icon: "icon-bookmark", tab_text: "Final Manuscript", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:29:36", updated_at: "2015-02-04 04:20:53"},
  {id: 26, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "publish_book", name: "Publish Book", icon: "icon-star", tab_text: "Publish Book", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:30:00", updated_at: "2015-02-04 05:33:33"},
  {id: 27, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "market_release_date", name: "Mkt Rel", icon: "icon-calendar", tab_text: "Mkt Rel", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:31:22", updated_at: "2015-02-04 04:23:51"},
  {id: 28, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "media_kit", name: "Media Kit", icon: "icon-comment", tab_text: "Media Kit", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:31:52", updated_at: "2015-02-04 04:30:16"},
  {id: 29, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "print_corner", name: "Print", icon: "icon-envelope", tab_text: "Print", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:32:16", updated_at: "2015-02-04 04:55:11"},
  {id: 30, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "blog_tour", name: "Blog Tour", icon: "icon-money", tab_text: "Blog Tour", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:32:37", updated_at: "2015-02-04 05:02:25"},
  {id: 31, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "price_promotion", name: "Promos", icon: "icon-money", tab_text: "Promos", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:32:52", updated_at: "2015-02-04 05:04:46"},
  {id: 32, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "kdp_select_enrollment", name: "KDP Select", icon: "icon-bookmark", tab_text: "KDP Select", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:34:13", updated_at: "2015-02-04 05:35:30"},
  {id: 33, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "kdp_select_update", name: "KDP Update", icon: "icon-bookmark", tab_text: "KDP Update", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:34:28", updated_at: "2015-02-04 05:35:52"},
  {id: 34, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "marketing_expense", name: "Marketing Expense", icon: "icon-money", tab_text: "Mkt $", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:35:11", updated_at: "2015-02-04 05:18:49"},
  {id: 36, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "production_expense", name: "Production Expense", icon: "icon-money", tab_text: "Prod $", intro_video: "", days_to_complete: nil, created_at: "2015-02-02 23:35:29", updated_at: "2015-02-04 05:31:17"},
  {id: 37, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "submit_proofread", name: "Submit Proofread", icon: "icon-ok-sign", tab_text: "Submit Proofread", intro_video: "", days_to_complete: nil, created_at: "2015-02-03 00:08:14", updated_at: "2015-02-03 00:12:27"},
  {id: 38, workflow_id: nil, next_id: nil, rejected_task_id: nil, partial: "team_change", name: "Team Change", icon: "icon-bookmark", tab_text: "Team Change", intro_video: "", days_to_complete: nil, created_at: "2015-02-03 11:09:39", updated_at: "2015-02-03 11:21:19"}
])
TaskPerformer.create!([
  {id: 1, task_id: 7, role_id: 4, created_at: "2015-01-20 09:48:02", updated_at: "2015-01-20 09:48:02"},
  {id: 2, task_id: 1, role_id: 2, created_at: "2015-01-20 11:47:51", updated_at: "2015-01-20 11:47:51"},
  {id: 3, task_id: 1, role_id: 3, created_at: "2015-01-20 11:47:51", updated_at: "2015-01-20 11:47:51"},
  {id: 4, task_id: 9, role_id: 1, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 5, task_id: 9, role_id: 2, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 6, task_id: 9, role_id: 3, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 7, task_id: 9, role_id: 4, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 8, task_id: 9, role_id: 6, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 9, task_id: 9, role_id: 5, created_at: "2015-02-03 09:57:52", updated_at: "2015-02-03 09:57:52"},
  {id: 10, task_id: 10, role_id: 1, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 11, task_id: 10, role_id: 2, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 12, task_id: 10, role_id: 3, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 13, task_id: 10, role_id: 4, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 14, task_id: 10, role_id: 6, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 15, task_id: 10, role_id: 5, created_at: "2015-02-03 09:58:15", updated_at: "2015-02-03 09:58:15"},
  {id: 16, task_id: 11, role_id: 1, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 17, task_id: 11, role_id: 2, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 18, task_id: 11, role_id: 3, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 19, task_id: 11, role_id: 4, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 20, task_id: 11, role_id: 6, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 21, task_id: 11, role_id: 5, created_at: "2015-02-03 09:58:40", updated_at: "2015-02-03 09:58:40"},
  {id: 22, task_id: 12, role_id: 1, created_at: "2015-02-03 10:00:20", updated_at: "2015-02-03 10:00:20"},
  {id: 23, task_id: 12, role_id: 2, created_at: "2015-02-03 10:00:20", updated_at: "2015-02-03 10:00:20"},
  {id: 24, task_id: 12, role_id: 3, created_at: "2015-02-03 10:00:20", updated_at: "2015-02-03 10:00:20"},
  {id: 26, task_id: 12, role_id: 6, created_at: "2015-02-03 10:00:20", updated_at: "2015-02-03 10:00:20"},
  {id: 27, task_id: 12, role_id: 5, created_at: "2015-02-03 10:00:20", updated_at: "2015-02-03 10:00:20"},
  {id: 28, task_id: 13, role_id: 1, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 29, task_id: 13, role_id: 2, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 30, task_id: 13, role_id: 3, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 31, task_id: 13, role_id: 4, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 32, task_id: 13, role_id: 6, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 33, task_id: 13, role_id: 5, created_at: "2015-02-03 10:00:37", updated_at: "2015-02-03 10:00:37"},
  {id: 34, task_id: 14, role_id: 2, created_at: "2015-02-03 10:00:51", updated_at: "2015-02-03 10:00:51"},
  {id: 36, task_id: 5, role_id: 1, created_at: "2015-02-03 10:02:50", updated_at: "2015-02-03 10:02:50"},
  {id: 37, task_id: 6, role_id: 2, created_at: "2015-02-03 10:03:30", updated_at: "2015-02-03 10:03:30"},
  {id: 39, task_id: 37, role_id: 5, created_at: "2015-02-03 10:04:23", updated_at: "2015-02-03 10:04:23"},
  {id: 40, task_id: 2, role_id: 1, created_at: "2015-02-03 10:56:28", updated_at: "2015-02-03 10:56:28"},
  {id: 41, task_id: 38, role_id: 1, created_at: "2015-02-03 11:09:39", updated_at: "2015-02-03 11:09:39"},
  {id: 42, task_id: 4, role_id: 1, created_at: "2015-02-03 11:24:02", updated_at: "2015-02-03 11:24:02"},
  {id: 43, task_id: 15, role_id: 1, created_at: "2015-02-03 11:37:16", updated_at: "2015-02-03 11:37:16"},
  {id: 44, task_id: 24, role_id: 1, created_at: "2015-02-04 04:14:05", updated_at: "2015-02-04 04:14:05"},
  {id: 45, task_id: 24, role_id: 2, created_at: "2015-02-04 04:14:05", updated_at: "2015-02-04 04:14:05"},
  {id: 46, task_id: 12, role_id: 4, created_at: "2015-02-07 00:23:19", updated_at: "2015-02-07 00:23:19"}
])
TeamMembership.create!([
  {id: 1, project_id: 1, member_id: 1, role_id: 1, percentage: 33.0, created_at: "2015-01-19 22:19:05", updated_at: "2015-01-19 22:19:05"},
  {id: 3, project_id: 1, member_id: 4, role_id: 2, percentage: 20.0, created_at: "2015-01-19 22:40:44", updated_at: "2015-01-19 22:40:44"},
  {id: 4, project_id: 1, member_id: 2, role_id: 6, percentage: 4.0, created_at: "2015-01-20 02:08:36", updated_at: "2015-01-20 02:08:36"},
  {id: 5, project_id: 1, member_id: 6, role_id: 3, percentage: 4.0, created_at: "2015-01-20 02:09:29", updated_at: "2015-01-20 02:09:29"},
  {id: 6, project_id: 1, member_id: 7, role_id: 5, percentage: 2.0, created_at: "2015-01-20 04:06:35", updated_at: "2015-01-20 04:06:35"},
  {id: 8, project_id: 1, member_id: 5, role_id: 4, percentage: 7.0, created_at: "2015-01-20 04:19:47", updated_at: "2015-01-20 04:19:47"},
  {id: 9, project_id: 2, member_id: 4, role_id: 1, percentage: 33.0, created_at: "2015-01-21 05:22:40", updated_at: "2015-02-06 23:36:41"},
  {id: 10, project_id: 2, member_id: 4, role_id: 2, percentage: 20.0, created_at: "2015-01-21 05:24:09", updated_at: "2015-02-06 23:36:41"},
  {id: 11, project_id: 2, member_id: 5, role_id: 4, percentage: 7.0, created_at: "2015-01-21 05:27:54", updated_at: "2015-01-21 05:27:54"}
])
UnlockedTask.create!([
  {id: 7, task_id: 1, unlocked_task_id: 2, created_at: "2015-01-20 14:16:46", updated_at: "2015-01-20 14:16:46"},
  {id: 11, task_id: 2, unlocked_task_id: 1, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 12, task_id: 2, unlocked_task_id: 3, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 13, task_id: 2, unlocked_task_id: 4, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 14, task_id: 2, unlocked_task_id: 5, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 15, task_id: 2, unlocked_task_id: 6, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 16, task_id: 2, unlocked_task_id: 7, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 17, task_id: 2, unlocked_task_id: 8, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 18, task_id: 2, unlocked_task_id: 9, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 19, task_id: 2, unlocked_task_id: 10, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 20, task_id: 2, unlocked_task_id: 11, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 21, task_id: 2, unlocked_task_id: 12, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 22, task_id: 2, unlocked_task_id: 13, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 23, task_id: 2, unlocked_task_id: 14, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 24, task_id: 2, unlocked_task_id: 15, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 25, task_id: 2, unlocked_task_id: 16, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 26, task_id: 2, unlocked_task_id: 17, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 27, task_id: 2, unlocked_task_id: 18, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 28, task_id: 2, unlocked_task_id: 19, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 29, task_id: 2, unlocked_task_id: 20, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 30, task_id: 2, unlocked_task_id: 21, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 31, task_id: 2, unlocked_task_id: 22, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 32, task_id: 2, unlocked_task_id: 23, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 33, task_id: 2, unlocked_task_id: 24, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 34, task_id: 2, unlocked_task_id: 25, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 35, task_id: 2, unlocked_task_id: 26, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 36, task_id: 2, unlocked_task_id: 27, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 37, task_id: 2, unlocked_task_id: 28, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 38, task_id: 2, unlocked_task_id: 29, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 39, task_id: 2, unlocked_task_id: 30, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 40, task_id: 2, unlocked_task_id: 31, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 41, task_id: 2, unlocked_task_id: 32, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 42, task_id: 2, unlocked_task_id: 33, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 43, task_id: 2, unlocked_task_id: 34, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 44, task_id: 2, unlocked_task_id: 36, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 45, task_id: 2, unlocked_task_id: 37, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 46, task_id: 2, unlocked_task_id: 38, created_at: "2015-02-05 07:57:14", updated_at: "2015-02-05 07:57:14"},
  {id: 47, task_id: 2, unlocked_task_id: 2, created_at: "2015-02-05 07:58:11", updated_at: "2015-02-05 07:58:11"}
])

Workflow.create!([
  {id: 1, name: "Production", root_task_id: 5, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-20 00:42:17"},
  {id: 2, name: "Marketing", root_task_id: nil, created_at: "2015-01-19 10:01:10", updated_at: "2015-01-19 10:01:10"},
  {id: 3, name: "Design", root_task_id: nil, created_at: "2015-01-20 09:37:58", updated_at: "2015-01-20 09:37:58"}
])
