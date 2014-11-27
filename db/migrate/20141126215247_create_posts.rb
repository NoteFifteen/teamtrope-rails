class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.datetime :post_date
      t.integer :author_id
      t.text :content

      t.timestamps
    end
    add_index :posts, [:post_date, :title]
    add_index :posts, [:post_date, :title, :author_id]
  end
end
