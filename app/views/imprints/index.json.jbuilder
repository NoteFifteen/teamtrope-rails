json.array!(@imprints) do |imprint|
  json.extract! imprint, :id, :name
  json.url imprint_url(imprint, format: :json)
end
