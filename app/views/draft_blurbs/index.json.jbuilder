json.array!(@draft_blurbs) do |draft_blurb|
  json.extract! draft_blurb, :id, :project_id, :draft_blurb
  json.url draft_blurb_url(draft_blurb, format: :json)
end
