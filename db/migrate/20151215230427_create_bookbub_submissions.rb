class CreateBookbubSubmissions < ActiveRecord::Migration
  def change
    create_table :bookbub_submissions do |t|
      t.references :project, index: true
      t.integer :submitted_by_id
      t.string :author
      t.string :title
      t.string :asin
      t.string :asin_linked_url
      t.float :current_price
      t.float :num_stars
      t.integer :num_reviews
      t.integer :num_pages

      t.timestamps
    end
  end
end
