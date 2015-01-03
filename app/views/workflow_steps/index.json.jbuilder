json.array!(@workflow_steps) do |workflow_step|
  json.extract! workflow_step, :id, :workflow_id, :task_id, :next_step_id
  json.url workflow_step_url(workflow_step, format: :json)
end
