json.array!(@tasks) do |task|
  json.extract! task, :id, :workflow_id, :next_id, :rejected_task_id, :partial, :name, :icon, :tab_text, :intro_video, :days_to_complete, :performer_ids, :unlocked_task_ids
  json.url task_url(task, format: :json)
end
