json.array!(@final_manuscripts) do |final_manuscript|
  json.extract! final_manuscript, :id
  json.url final_manuscript_url(final_manuscript, format: :json)
end
