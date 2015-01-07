class CreateProjectTypeWorkflows < ActiveRecord::Migration
  def change
    create_table :project_type_workflows do |t|
      t.references :workflow, index: true
      t.references :project_type, index: true

      t.timestamps
    end
    add_index :project_type_workflows, [:workflow_id, :project_type_id]
  end
end
