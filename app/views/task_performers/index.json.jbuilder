json.array!(@task_performers) do |task_performer|
  json.extract! task_performer, :id
  json.url task_performer_url(task_performer, format: :json)
end
