json.array!(@rights_back_requests) do |rights_back_request|
  json.extract! rights_back_request, :id, :project_id, :submitted_by_id, :submitted_by_name, :title, :author, :reason, :proofed, :edited, :published
  json.url rights_back_request_url(rights_back_request, format: :json)
end
