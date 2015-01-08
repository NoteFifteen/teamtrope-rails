class CreateUnlockedTasks < ActiveRecord::Migration
  def change
    create_table :unlocked_tasks do |t|
      t.references :task, index: true
      t.integer :unlocked_task_id

      t.timestamps
    end
    add_index :unlocked_tasks, :unlocked_task_id
  end
end
