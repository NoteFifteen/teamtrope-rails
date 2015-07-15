class AddWorkflowTimestampsToPgtr < ActiveRecord::Migration
  def up
    add_column :project_grid_table_rows, :production_task_last_update, :datetime, after: :production_task_name
    add_column :project_grid_table_rows, :marketing_task_last_update, :datetime, after: :marketing_task_name
    add_column :project_grid_table_rows, :design_task_last_update, :datetime, after: :design_task_name
  end

  def down
    remove_column :project_grid_table_rows, :production_task_last_update, :datetime
    remove_column :project_grid_table_rows, :marketing_task_last_update, :datetime
    remove_column :project_grid_table_rows, :design_task_last_update, :datetime
  end

end
