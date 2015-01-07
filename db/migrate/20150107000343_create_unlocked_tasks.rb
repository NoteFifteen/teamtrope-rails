class CreateUnlockedTasks < ActiveRecord::Migration
  def change
    create_table :unlocked_tasks do |t|
      t.references :workflow_step, index: true
      t.integer :unlocked_task_id

      t.timestamps
    end
    add_index :unlocked_tasks, :unlocked_task_id
  end
end
