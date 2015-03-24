class CreatePublicationFactSheets < ActiveRecord::Migration
  def change
    create_table :publication_fact_sheets do |t|
      t.references :project, index: true
      t.string :author_name
      t.string :series_name
      t.string :series_number
      t.text :description
      t.text :author_bio
      t.text :endorsements
      t.string :one_line_blurb
      t.float :print_price
      t.float :ebook_price
      t.string :bisac_code_one
      t.string :bisac_code_two
      t.string :bisac_code_three
      t.text :search_terms
      t.string :age_range
      t.string :paperback_cover_type

      t.timestamps
    end
  end
end
