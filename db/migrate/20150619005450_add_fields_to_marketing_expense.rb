class AddFieldsToMarketingExpense < ActiveRecord::Migration
  def change
    add_column :marketing_expenses, :other_service_provider, :string, after: :other_information
    add_column :marketing_expenses, :other_type, :string, after: :other_service_provider
  end
end
