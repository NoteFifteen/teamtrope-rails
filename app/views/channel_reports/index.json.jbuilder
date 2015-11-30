json.array!(@channel_reports) do |channel_report|
  json.extract! channel_report, :id, :scan_date
  json.url channel_report_url(channel_report, format: :json)
end
