json.array!(@published_files) do |published_file|
  json.extract! published_file, :id
  json.url published_file_url(published_file, format: :json)
end
