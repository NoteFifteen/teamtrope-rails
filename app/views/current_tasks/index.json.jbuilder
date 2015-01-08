json.array!(@current_tasks) do |current_task|
  json.extract! current_task, :id, :project_id, :task_id
  json.url current_task_url(current_task, format: :json)
end
