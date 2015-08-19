json.array!(@hellosign_documents) do |hellosign_document|
  json.extract! hellosign_document, :id, :hellosign_id, :status, :hellosignable_id
  json.url hellosign_document_url(hellosign_document, format: :json)
end
