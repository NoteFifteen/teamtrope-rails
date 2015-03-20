json.array!(@blog_tours) do |blog_tour|
  json.extract! blog_tour, :id, :project_id, :cost, :tour_type, :blog_tour_service, :number_of_stops, :start_date, :end_date
  json.url blog_tour_url(blog_tour, format: :json)
end
