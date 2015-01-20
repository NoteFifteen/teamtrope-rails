json.array!(@project_views) do |project_view|
  json.extract! project_view, :id, :project_type_id
  json.url project_view_url(project_view, format: :json)
end
