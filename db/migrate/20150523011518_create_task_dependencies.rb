class CreateTaskDependencies < ActiveRecord::Migration
  def change
    create_table :task_dependencies do |t|
      t.integer :main_task_id
      t.integer :dependent_task_id

      t.timestamps
    end
    add_index :task_dependencies, :main_task_id
    add_index :task_dependencies, :dependent_task_id
    add_index :task_dependencies, [:main_task_id, :dependent_task_id]
  end
end
