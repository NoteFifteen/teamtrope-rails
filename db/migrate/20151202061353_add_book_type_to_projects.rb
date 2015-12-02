class AddBookTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :book_type, :string
  end
end
