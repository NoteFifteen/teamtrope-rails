json.array!(@publication_fact_sheets) do |publication_fact_sheet|
  json.extract! publication_fact_sheet, :id, :project_id, :author_name, :series_name, :series_number, :description, :author_bio, :endorsements, :one_line_blurb, :print_price, :ebook_price, :bisac_code_one, :bisac_code_two, :bisac_code_three, :search_terms, :age_range, :paperback_cover_type
  json.url publication_fact_sheet_url(publication_fact_sheet, format: :json)
end
