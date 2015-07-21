json.array!(@cover_concepts) do |cover_concept|
  json.extract! cover_concept, :id
  json.url cover_concept_url(cover_concept, format: :json)
end
