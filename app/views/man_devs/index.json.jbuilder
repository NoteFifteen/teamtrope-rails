json.array!(@man_devs) do |man_dev|
  json.extract! man_dev, :id, :project_id, :man_dev_decision, :man_dev_end_date
  json.url man_dev_url(man_dev, format: :json)
end
