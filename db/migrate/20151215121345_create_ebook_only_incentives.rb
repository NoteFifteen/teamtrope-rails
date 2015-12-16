class CreateEbookOnlyIncentives < ActiveRecord::Migration
  def change
    create_table :ebook_only_incentives do |t|
      t.references :project, index: true
      t.string :title
      t.string :author_name
      t.date :publication_date
      t.float :retail_price
      t.text :blurb
      t.string :website_one
      t.string :website_two
      t.string :website_three
      t.string :category_one
      t.string :category_two
      t.text :praise
      t.string :isbn

      t.timestamps
    end
  end
end
