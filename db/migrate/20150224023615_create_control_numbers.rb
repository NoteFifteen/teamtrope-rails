class CreateControlNumbers < ActiveRecord::Migration
  def change
    create_table :control_numbers do |t|
      t.references :project, index: true
      t.string :imprint
      t.float  :ebook_library_price
      t.string :asin
      t.string :apple_id
      t.string :epub_isbn
      t.string :hardback_isbn
      t.string :paperback_isbn
      t.string :parse_id

      t.timestamps
    end
  end
end
