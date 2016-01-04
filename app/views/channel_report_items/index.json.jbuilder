json.array!(@channel_report_items) do |channel_report_item|
  json.extract! channel_report_item, :id, :channel_report_id, :title, :kdp_select, :amazon, :apple, :nook, :amazon_link, :apple_link, :nook_link
  json.url channel_report_item_url(channel_report_item, format: :json)
end
