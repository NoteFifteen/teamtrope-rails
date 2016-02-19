class AddSubmitToLayoutFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :has_works_previously_published_with_booktrope, :boolean
    add_column :projects, :works_previously_published_with_booktrope, :text
    add_column :projects, :table_of_contents, :boolean
  end
end
