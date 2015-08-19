json.array!(@hellosign_document_types) do |hellosign_document_type|
  json.extract! hellosign_document_type, :id, :name, :subject, :message, :template_id, :signers, :ccs
  json.url hellosign_document_type_url(hellosign_document_type, format: :json)
end
