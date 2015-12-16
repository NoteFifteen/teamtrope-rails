json.array!(@ebook_only_incentives) do |ebook_only_incentive|
  json.extract! ebook_only_incentive, :id, :project_id, :title, :author_name, :publication_date, :retail_price, :blurb, :website_one, :website_two, :website_three, :category_one, :category_two, :praise, :isbn
  json.url ebook_only_incentive_url(ebook_only_incentive, format: :json)
end
