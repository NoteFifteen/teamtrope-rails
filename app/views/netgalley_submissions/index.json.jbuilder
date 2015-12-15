json.array!(@netgalley_submissions) do |netgalley_submission|
  json.extract! netgalley_submission, :id, :project_id, :title, :author_name, :publication_date, :retail_price, :blurb, :website_one, :website_two, :website_three, :category_one, :category_two, :praise, :isbn
  json.url netgalley_submission_url(netgalley_submission, format: :json)
end
