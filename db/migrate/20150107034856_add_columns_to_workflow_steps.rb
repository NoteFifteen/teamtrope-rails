class AddColumnsToWorkflowSteps < ActiveRecord::Migration
  def change
    add_reference :workflow_steps, :phase, index: true
    add_column :workflow_steps, :horizontal_order, :integer
  end
end
