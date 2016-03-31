class CreateMonthlyPublishedBooks < ActiveRecord::Migration
  def change
    create_table :monthly_published_books do |t|
      t.date :report_date
      t.integer :published_monthly
      t.integer :published_total
      t.json :published_books

      t.timestamps
    end
    add_index :monthly_published_books, :report_date
  end
end
