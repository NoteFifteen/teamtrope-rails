class AddControlNumbersToProject < ActiveRecord::Migration
  def change
    add_column :projects, :apple_id, :string
    add_column :projects, :asin, :string
    add_column :projects, :epub_isbn_no_dash, :string
    add_column :projects, :createspace_isbn, :string
    add_column :projects, :hardback_isbn, :string
    add_column :projects, :lsi_isbn, :string
    add_column :projects, :isbn, :string
    add_column :projects, :ebook_isbn, :string
    add_column :projects, :parse_id, :string
  end
end
