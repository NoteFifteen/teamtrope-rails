json.array!(@required_roles) do |required_role|
  json.extract! required_role, :id, :role_id, :project_type_id, :suggested_percent
  json.url required_role_url(required_role, format: :json)
end
