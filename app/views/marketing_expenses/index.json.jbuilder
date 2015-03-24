json.array!(@marketing_expenses) do |marketing_expense|
  json.extract! marketing_expense, :id, :project_id, :invoice_due_date, :start_date, :end_date, :type_mask, :service_provider_mask, :cost, :other_information
  json.url marketing_expense_url(marketing_expense, format: :json)
end
