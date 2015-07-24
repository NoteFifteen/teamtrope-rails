json.array!(@media_kits) do |media_kit|
  json.extract! media_kit, :id
  json.url media_kit_url(media_kit, format: :json)
end
