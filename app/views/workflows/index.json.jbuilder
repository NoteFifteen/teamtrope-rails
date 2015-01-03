json.array!(@workflows) do |workflow|
  json.extract! workflow, :id, :name
  json.url workflow_url(workflow, format: :json)
end
