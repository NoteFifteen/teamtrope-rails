class StripSlashesFromIsbnNumbers < ActiveRecord::Migration

  # Strip out the dashes in the ISBN fields
  def change

    # Enforce a default type of nil (null) because it's the safest for unique constraints
    change_column :control_numbers, :asin, :string, :default => nil
    change_column :control_numbers, :apple_id, :string, :default => nil
    change_column :control_numbers, :epub_isbn, :string, :default => nil
    change_column :control_numbers, :hardback_isbn, :string, :default => nil
    change_column :control_numbers, :paperback_isbn, :string, :default => nil

    # Strip out the dashes, convert empty to nil for unique constraints to work
    ControlNumber.all.each do |cn|
      cn.asin           = nil unless cn.asin.nil?            || cn.asin.length > 0
      cn.apple_id       = nil unless cn.apple_id.nil?        || cn.apple_id.length > 0
      cn.epub_isbn      = nil unless cn.epub_isbn.nil?       || cn.epub_isbn.length > 0
      cn.hardback_isbn  = nil unless cn.hardback_isbn.nil?   || cn.hardback_isbn.length > 0
      cn.paperback_isbn = nil unless cn.paperback_isbn.nil?  || cn.paperback_isbn.length > 0
    end

    # Add indexes so it's easy to search, force unique
    add_index :control_numbers, :asin, unique: true
    add_index :control_numbers, :apple_id, unique: true
    add_index :control_numbers, :epub_isbn, unique: true
    add_index :control_numbers, :hardback_isbn, unique: true
    add_index :control_numbers, :paperback_isbn, unique: true

 end
end
