json.array!(@project_layouts) do |project_layout|
  json.extract! project_layout, :id, :project_id, :exact_name_on_copyright, :final_page_count, :layout_approval_issue_list, :layout_approved, :layout_approved_date, :layout_notes, :page_header_display_name, :pen_name, :use_pen_name_for_copyright, :use_pen_name_on_title
  json.url project_layout_url(project_layout, format: :json)
end
