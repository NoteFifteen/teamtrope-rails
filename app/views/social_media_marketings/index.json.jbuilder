json.array!(@social_media_marketings) do |social_media_marketing|
  json.extract! social_media_marketing, :id, :project_id, :author_facebook_page, :author_central_account_link, :website_url, :twitter, :pintrest, :goodreads
  json.url social_media_marketing_url(social_media_marketing, format: :json)
end
