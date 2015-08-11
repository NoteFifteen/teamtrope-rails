class CreateReportDataMonthlySales < ActiveRecord::Migration

  # This is an aggregate table for all sales for a project, by source, for a given year and month
  def change
    create_table :report_data_monthly_sales do |t|
      t.references :report_data_file, index: true
      t.references :report_data_source, index: true
      t.references :project, index: true, :default => nil
      t.references :report_data_kdp_type, :default => nil
      t.references :report_data_country, :default => nil
      t.boolean :is_valid
      t.integer :year
      t.integer :month
      t.integer :quantity, :default => 0
      t.float :revenue, :default => 0.0

      t.timestamps
    end

    ## Note: We should always query the is_valid column since we may want to invalidate by not
    ## delete older or invalid reporting data which may be replaced!

    # We'll certainly want to report by year & month
    add_index :report_data_monthly_sales, [:year, :month, :is_valid], name: 'index_monthly_sales'

    # This is also likely, to see sales for a given source and time period
    add_index :report_data_monthly_sales, [:report_data_source_id, :year, :month, :is_valid], name: 'index_monthly_sales_by_source'

  end
end
