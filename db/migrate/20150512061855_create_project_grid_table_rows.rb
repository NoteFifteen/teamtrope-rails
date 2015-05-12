class CreateProjectGridTableRows < ActiveRecord::Migration
  def change
    create_table :project_grid_table_rows do |t|
      t.references :project, index: true
      t.string :title
      t.string :genre
      t.string :author
      t.string :editor
      t.string :proofreader
      t.string :project_manager
      t.string :book_manager
      t.string :cover_designer
      t.string :imprint
      t.string :teamroom_link
      t.integer :production_task_id
      t.string :production_task_name
      t.integer :marketing_task_id
      t.string :marketing_task_name
      t.integer :design_task_id
      t.string :design_task_name

      t.timestamps
    end
    add_index :project_grid_table_rows, :title
    add_index :project_grid_table_rows, :production_task_id
    add_index :project_grid_table_rows, :marketing_task_id
    add_index :project_grid_table_rows, :marketing_task_name
    add_index :project_grid_table_rows, :design_task_id
    add_index :project_grid_table_rows, :design_task_name
  end
end
