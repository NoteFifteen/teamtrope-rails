json.array!(@document_import_queues) do |document_import_queue|
  json.extract! document_import_queue, :id, :wp_id, :attachment_id, :fieldname, :url, :status, :dyno_id, :error
  json.url document_import_queue_url(document_import_queue, format: :json)
end
