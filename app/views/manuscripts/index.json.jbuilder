json.array!(@manuscripts) do |manuscript|
  json.extract! manuscript, :id
  json.url manuscript_url(manuscript, format: :json)
end
