json.array!(@prefunk_enrollments) do |prefunk_enrollment|
  json.extract! prefunk_enrollment, :id, :project_id, :user_id
  json.url prefunk_enrollment_url(prefunk_enrollment, format: :json)
end
