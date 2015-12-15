class CreateNetgalleySubmissions < ActiveRecord::Migration
  def change
    create_table :netgalley_submissions do |t|
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
