json.array!(@current_steps) do |current_step|
  json.extract! current_step, :id, :project_id, :workflow_step_id
  json.url current_step_url(current_step, format: :json)
end
