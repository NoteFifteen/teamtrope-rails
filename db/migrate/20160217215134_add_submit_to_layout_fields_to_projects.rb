class AddSubmitToLayoutFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :table_of_contents, :boolean
  end
end
