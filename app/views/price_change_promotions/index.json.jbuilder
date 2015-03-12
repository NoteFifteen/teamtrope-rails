json.array!(@price_change_promotions) do |price_change_promotion|
  json.extract! price_change_promotion, :id, :start_date, :end_date, :price_promotion, :price_after_promotion, :type_mask, :sites, :project_id
  json.url price_change_promotion_url(price_change_promotion, format: :json)
end
