class AddArchivedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :archived, :boolean, default: false
    add_column :project_grid_table_rows, :archived, :boolean, default: false
  end
end
