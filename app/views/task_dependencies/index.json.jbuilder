json.array!(@task_dependencies) do |task_dependency|
  json.extract! task_dependency, :id, :main_task_id, :dependent_task_id
  json.url task_dependency_url(task_dependency, format: :json)
end
