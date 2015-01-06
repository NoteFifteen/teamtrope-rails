json.array!(@project_type_workflows) do |project_type_workflow|
  json.extract! project_type_workflow, :id, :Workflow_id, :ProjectType_id
  json.url project_type_workflow_url(project_type_workflow, format: :json)
end
