json.array!(@approve_blurbs) do |approve_blurb|
  json.extract! approve_blurb, :id, :project_id, :blurb_notes, :blurb_approval_decision, :blurb_approval_date
  json.url approve_blurb_url(approve_blurb, format: :json)
end
