class AddColumnsToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :wp_id, :integer
    add_index :genres, :wp_id, unique: true
  end
end
