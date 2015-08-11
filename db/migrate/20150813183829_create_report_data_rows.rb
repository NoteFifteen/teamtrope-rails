class CreateReportDataRows < ActiveRecord::Migration
  def change
    create_table :report_data_rows do |t|
      t.references :report_data_file, index: true
      t.references :project, index: true
      t.boolean :is_valid, :default => true
      t.boolean :is_matched, :default => false
      t.boolean :is_processed, :default => false
      t.string :source_table_name, index: true
      t.date :start_date, index: true
      t.date :end_date
      t.integer :quantity
      t.float :revenue_multiccy
      t.string :currency_use
      t.string :country
      t.string :bn_identifier, index: true
      t.string :epub_isbn, index: true
      t.string :paperback_isbn, index: true
      t.string :apple_identifier, index: true
      t.string :asin, index: true
      t.string :kdp_royalty_type
      t.string :kdp_transaction_type
      t.string :list_price_multiccy
      t.string :isbn_hardcover, index: true
      t.float :unit_revenue
      t.float :revenue_usd

      t.timestamps
    end
  end
end
