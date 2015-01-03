json.array!(@tasks) do |task|
  json.extract! task, :id, :type, :name, :icon, :tab_text, :intro_video, :days_to_complete
  json.url task_url(task, format: :json)
end
