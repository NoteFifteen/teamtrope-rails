json.array!(@bookbub_submissions) do |bookbub_submission|
  json.extract! bookbub_submission, :id, :project_id, :submitted_by_id, :author, :title, :asin, :asin_linked_url, :current_price, :num_stars, :num_reviews, :avg_rating, :num_pages
  json.url bookbub_submission_url(bookbub_submission, format: :json)
end
