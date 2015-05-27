class CreateProductionExpenses < ActiveRecord::Migration
  def change
    create_table :production_expenses do |t|
      t.references :project, index: true
      t.integer :total_quantity_ordered
      t.float :total_cost
      t.integer :complimentary_quantity
      t.float :complimentary_cost
      t.integer :author_advance_quantity
      t.float :author_advance_cost
      t.integer :purchased_quantity
      t.float :purchased_cost
      t.float :paypal_invoice_amount
      t.text :calculation_explanation
      t.integer :marketing_quantity
      t.integer :additional_cost_mask
      t.float :additional_team_cost
      t.float :additional_booktrope_cost
      t.date :effective_date

      t.timestamps
    end
  end
end
