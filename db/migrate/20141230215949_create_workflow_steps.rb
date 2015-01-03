class CreateWorkflowSteps < ActiveRecord::Migration
  def change
    create_table :workflow_steps do |t|
      t.references :workflow, index: true
      t.references :task, index: true
      t.integer :next_step_id
      t.integer :rejected_step_id

      t.timestamps
    end
    add_index :workflow_steps, [:workflow_id, :task_id], unique: true
    add_index :workflow_steps, :next_step_id
    add_index :workflow_steps, :rejected_step_id
  end
end
