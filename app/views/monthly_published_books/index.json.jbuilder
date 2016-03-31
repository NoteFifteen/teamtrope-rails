json.array!(@monthly_published_books) do |monthly_published_book|
  json.extract! monthly_published_book, :id, :report_date, :published_monthly, :published_total, :published_books
  json.url monthly_published_book_url(monthly_published_book, format: :json)
end
