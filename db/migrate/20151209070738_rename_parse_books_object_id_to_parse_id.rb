class RenameParseBooksObjectIdToParseId < ActiveRecord::Migration
  def up
    rename_column :parse_books, :object_id, :parse_id
  end

  def down
    rename_column :parse_books, :parse_id, :object_id
  end
end
