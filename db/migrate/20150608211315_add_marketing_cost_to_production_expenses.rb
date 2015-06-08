class AddMarketingCostToProductionExpenses < ActiveRecord::Migration
  def change
    add_column :production_expenses, :marketing_cost, :float
  end
end
