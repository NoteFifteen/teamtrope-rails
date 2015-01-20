json.array!(@tabs) do |tab|
  json.extract! tab, :id, :task_id, :phase_id, :order
  json.url tab_url(tab, format: :json)
end
