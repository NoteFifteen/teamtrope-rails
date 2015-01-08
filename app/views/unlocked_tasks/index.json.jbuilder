json.array!(@unlocked_tasks) do |unlocked_task|
  json.extract! unlocked_task, :id, :task_id, :unlocked_task_id
  json.url unlocked_task_url(unlocked_task, format: :json)
end
