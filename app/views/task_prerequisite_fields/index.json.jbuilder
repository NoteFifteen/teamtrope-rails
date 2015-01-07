json.array!(@task_prerequisite_fields) do |task_prerequisite_field|
  json.extract! task_prerequisite_field, :id, :workflow_step_id, :field_name
  json.url task_prerequisite_field_url(task_prerequisite_field, format: :json)
end
