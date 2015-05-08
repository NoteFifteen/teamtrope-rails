json.array!(@kdp_select_enrollments) do |kdp_select_enrollment|
  json.extract! kdp_select_enrollment, :id, :project_id, :member_id, :enrollment_date, :update_type, :update_data
  json.url kdp_select_enrollment_url(kdp_select_enrollment, format: :json)
end
