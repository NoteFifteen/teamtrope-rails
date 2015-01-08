class CreateCurrentTasks < ActiveRecord::Migration
  def change
    create_table :current_tasks do |t|
      t.references :project, index: true
      t.references :task, index: true

      t.timestamps
    end
    add_index :current_tasks, [:project_id, :task_id], unique: true
  end
end
