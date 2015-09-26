json.array!(@cover_templates) do |cover_template|
  json.extract! cover_template, :id, :raw_cover, :alternative_cover, :createspace_cover, :ebook_front_cover, :lightning_source_cover, :font_license, :font_list
  json.url cover_template_url(cover_template, format: :json)
end
