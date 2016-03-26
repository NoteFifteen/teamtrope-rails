class AddRolePercentageToProjectGridTableRows < ActiveRecord::Migration
  def change
    add_column :project_grid_table_rows, :authors_pct, :text
    add_column :project_grid_table_rows, :editors_pct, :text
    add_column :project_grid_table_rows, :book_managers_pct, :text
    add_column :project_grid_table_rows, :cover_designers_pct, :text
    add_column :project_grid_table_rows, :project_managers_pct, :text
    add_column :project_grid_table_rows, :proofreaders_pct, :text
    add_column :project_grid_table_rows, :total_pct, :float
  end
end
