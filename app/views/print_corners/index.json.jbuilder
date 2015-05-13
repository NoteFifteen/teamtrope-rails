json.array!(@print_corners) do |print_corner|
  json.extract! print_corner, :id, :project_id, :user_id, :order_type, :first_order, :additional_order, :over_125, :billing_acceptance, :quantity, :has_author_profile, :has_marketing_plan, :shipping_recipient, :shipping_address_street_1, :shipping_address_street_2, :shipping_address_city, :shipping_address_state, :shipping_address_zip, :marketing_plan_link, :marketing_copy_message, :contact_phone, :expedite_instructions
  json.url print_corner_url(print_corner, format: :json)
end
