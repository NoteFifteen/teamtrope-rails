class AddTaskDisplayNamesToProjectGridTableRows < ActiveRecord::Migration
  def change
    add_column :project_grid_table_rows, :production_task_display_name, :string
    add_column :project_grid_table_rows, :design_task_display_name, :string
    add_column :project_grid_table_rows, :marketing_task_display_name, :string
  end
end
