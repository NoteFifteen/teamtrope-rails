class CreateMarketingExpenses < ActiveRecord::Migration
  def change
    create_table :marketing_expenses do |t|
      t.references :project, index: true
      t.date :invoice_due_date
      t.date :start_date
      t.date :end_date
      t.integer :type_mask
      t.integer :service_provider_mask
      t.float :cost
      t.text :other_information

      t.timestamps
    end
  end
end
