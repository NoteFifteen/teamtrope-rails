json.array!(@production_expenses) do |production_expense|
  json.extract! production_expense, :id, :project_id, :total_quantity_ordered, :total_cost, :complimentary_quantity, :complimentary_cost, :author_advance_quantity, :author_advance_cost, :purchased_quantity, :purchased_cost, :paypal_invoice_amount, :calculation_explanation, :marketing_quantity, :additional_cost_mask, :additional_team_cost, :additional_booktrope_cost, :effective_date
  json.url production_expense_url(production_expense, format: :json)
end
