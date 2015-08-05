json.array!(@artwork_rights_requests) do |artwork_rights_request|
  json.extract! artwork_rights_request, :id, :email, :full_name, :role_type
  json.url artwork_rights_request_url(artwork_rights_request, format: :json)
end
